#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

=== ComponentAnalyser

The `ComponentAnalyser` is responsible for the symbolic execution of a single component. Each component has its own `ComponentAnalyser` and during its initialisation it will perform the following steps once:

1. *Angr Initialisation:* Create an `angr.project` for the given binary and compute a `CFGEmulated`.
2. *IO Funtion Identification:* Search for the addresses of the IO functions specified in the configuration.
3. *Find entry states:* Symbolically execute the binary from its entry point towards the found input functions in order to retrieve the `state` at which the input functions are called. From there, following analyis runs can be started without having to find the entry states every time.
4. *Setup OutputChecker:* Tell the `OutputChecker` which addresses are the output functions we're interested in.
5. *Input Function Hooking:* Use the `InputHookRegistry` to hook the input functions with a matching `InputHook`.

Now the `ComponentAnalyser` is ready for analysis. The `analyse()` method will start this process and initiates the following steps:
6. *analyse():* Create a new `InputTracker` for this component and analyse every possible combination of inputs available in the bus. If the component has not been analysed before and has no expected inputs, `InputTracker` will notice and just allow a single combination which consists of unconstrained inputs.
7. *Reset InputTracker:* Since we are running a new symbolic execution for all combinations of inputs for all entry points, we need to soft reset the `InputTracker` to prepare it for the new combination.
8. *Copy entry state* in order to not modify the originally computed state.
9. *Breakpoints:* Add breakpoints to all `call` instructions and perform an output `check()` before each call.
10. *Symbolic Execution:* Start a symbolic exploration from the entry state towards the output functions. If the component has no output functions, simply step for a fixed number of steps before analysing the constraints on the inputs.
11. *Output Check:* If a `call` instruction was hit, check if it is calling an output function and if so, parse it using a supported `OutputParser`.
12. *Write to the bus:* Write the parsed output to the bus.


#algorithm(
  ```python
  class ComponentAnalyser:
    angr_project = angr.Project()
    cfg = angr_project.analysis.CFGEmulated()
    input_addrs = find_addrs(Config.input_functions)
    output_adds = find_addrs(Config.output_functions)
    entry_states = get_sim_states(input_addrs
    input_hook_registry = InputHookRegistry()
    output_checker = setup_output_checker(output_addrs)
    for addr in input_addrs:
      angr.project.hook(addr, input_hook_registry.create_hook(addr))
   ```,
  caption: [Simplified view of the `ComponentAnalyser` Initialisation]
)


#algorithm(
  ```python
  class ComponentAnalyser:
    
    def analyse():
      InputTracker.new(component)
      while InputTracker.has_next_combination():
        for entry_state in entry_states:
          InputTracker.soft_reset()
          entry_state_copy = entry_state.copy()
          entry_state_copy.add_breakpoint(
            "call",
            when="before",
            action="capture_output"
          )
          if output_addrs:
            angr_project.explore()
          else:
            angr_project.step(1000)
          CANBus.update_graph()

      def capture_output(state):
        result = output_checker.check(state)
        if result:
          component.add_production(result.type)
          CANBus.write(result, InputTracker.get_consumed_msgs())
   ```,
  caption: [Simplified view `analyse()` method of the ComponentAnalyser]
)
