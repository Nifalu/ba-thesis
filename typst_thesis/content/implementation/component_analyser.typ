#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing, codly

=== ComponentAnalyser <canalyser>

The _ComponentAnalyser_ is responsible for the symbolic execution of a single component and managing its input and output behaviour. Each component has its own ComponentAnalyser, which performs the following steps once during initialisation:

#listing(caption: [Initialisation procedure of the `ComponentAnalyser`.], label: <im-canalyser1>)[
  #codly(offset: 0, highlights:(
    (line: 3, start: 41, end: 60),
    (line: 4, start: 14, end: 48),
  ))
    ```python
    def __init__(self, c):
      self.c = c
      self.proj = angr.Project(self.c.path, auto_load_libs=False)
      self.cfg = self.proj.analyses.CFGEmulated()
      self.input_addrs = self.find_addrs(Config.input_functions)
      self.output_addrs = self.find_addrs(Config.output_functions)
      self.entry_states = self.get_sim_states(self.input_addrs)
      self.output_checker = setup_output_checker(self.c, self.output_addrs)
      self.input_hook_registry = InputHookRegistry()
      for addr in self.input_addrs:
        hook = self.input_hook_registry.create_hook(addr)
        self.proj.hook(addr, hook)
    ```
]

1. The `auto_load_libs=False` parameter is used to prevent angr from including libraries like libc automatically. These libraries can be large and complex and drastically increase path explosion during symbolic execution. Instead, only the component's binary is loaded and external function calls are handled through default hooks by angr or custom hooks defined in the _InputHookRegistry_.

2. The `CFGEmulated()` call creates the CFG for the component. This operation symbolically executes the entire binary and is therefore computationally expensive. Read the discussion to this in @technical-limitations and @technical-improvements.

3. The `find_addrs()` function statically determines the addresses of the passed function names in the binary. On the otherhand, the `get_sim_states()` function symbolically executes towards the passed addresses and returns the states right before the addresses are called.

4. The `setup_output_checker()` function assigns the correct parsers for the output addresses.

5. The `InputHookRegistry()` provides the matching hooks for the passed functions which are then also hooked.

The _ComponentAnalyser_ is now initialised and ready to perform analysis runs on the component. By caching the _ComponentAnalyser_ instances, all the information retrieved during this initialisation step can be reused in consecutive analysis runs. Next up is the `analyse()` method which performs the actual symbolic execution and analysis of the component.

#listing(caption: [Analysing a single component.], label: <im-canalyser2>)[
  #codly(offset: 12, highlights:(
    (line: 3, start: 41, end: 60),
    (line: 4, start: 14, end: 48),
  ))
    ```python
    def analyse(self):
      InputTracker.track(self.c)
      while InputTracker.has_next_combination():
        for entry_state in self.entry_states:
          InputTracker.soft_reset()
          entry_state_copy = entry_state.copy()
          entry_state_copy.bp('call', 'before', action='capture_output')
          simgr = self.proj.factory.simgr(entry_state_copy)

          if self.output_addrs:
            simgr.explore(find=self.output_addrs, cfg=self.cfg)
          else:
            simgr.step(1000)
            if InputTracker.yield_unconstrained():
              OutputChecker.extract_consumed_ids(self.c, simgr)
              self.c.update_max_expected_inputs(InputTracker.max_inputs)
            CANBus.update_graph(self.c, InputTracker.get_consumed_msgs())
    ```
]

The `analyse()` function runs the symbolic execution of the component for all possible input combinations available or with unconstrained inputs if the component has not been analysed before. It does so by following these steps:

6. Set the `InputTracker` to track the current component. More details on the `InputTracker` in @io

7. There are possibly multiple messages on the bus that can be consumed by the component and depending in which order they are consumed, the component might produce different outcomes. So each combination is tried by looping through all of them.

8. For every combination of inputs, iterate through all entry states known for the component. This is usually just one state as components typically have simple and small binaries with a single entry point. In case we have multiple entry states, the `InputTracker` has to be soft-reset to prepare it for a new analysis run with the same combination of inputs.

9. Then the entry state is copied to keep the cached one clean for future runs. A breakpoint is added to each `call` instruction to capture the output before the call is made and a simulation manager from angr is created to perform the symbolic execution.

10. If the component has output functions, perform a symbolic exploration towards those functions. Else simply step through the binary for some time and then check the constraints on the inputs. This case distinction is necessary because some components (#eg actuators, hydraulics) might not write back to the bus so no output functions exist that can be used as _goal state_ for the symbolic exploration. If the latter is the case, `CANBus.update_graph()` is called directly as no new message is produced that could be written to the bus.

At this point, the symbolic execution has been performed. What remains is the `capture_output()` function which is called whenever a `call` instruction is encountered and checks whether it is calling an output function. If so, it passes the state to the corrsponding `OutputParser` to retrieve the symbolic output. More on that in @io

#listing(caption: [Capturing the output.], label: <im-canalyser3>)[
  #codly(offset: 12, highlights:(
    (line: 3, start: 41, end: 60),
    (line: 4, start: 14, end: 48),
  ))
    ```python
    def capture_output(self, state):
      result = self.output_checker.check(state, self.output_addrs)
      if result:
        self.c.update_max_expected_inputs(InputTracker.max_inputs)
        if result.type.is_symbolic:
          logger.warning(f"{c} produced symbolic message type: {result}")
        else:
          self.c.add_production(result.type.concrete_value)

      CANBus.write(result, InputTracker.get_consumed_msgs())
    ```
]

The if the `check()` function returns a result, the component has successfully produced an output message with the given input. The maximum number of expected inputs is updated, the produced message type is added to the component's list of produced messages and the message is passed to the `CANBus`.
