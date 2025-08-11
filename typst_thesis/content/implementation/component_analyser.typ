#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing

=== ComponentAnalyser

The *ComponentAnalyser* is responsible for the symbolic execution of a single component. Each component has its own ComponentAnalyser, which performs the following steps once during initialisation:

1. *Angr initialisation:* create an `angr.project` for the given binary and compute a CFGEmulated.
2. *IO function identification:* search for the addresses of the IO functions specified in the configuration.
3. *Find entry states:* symbolically execute the binary from its entry point towards the found input functions to retrieve the state at which the input functions are called. Subsequent analysis runs can then be started without having to find the entry states again.
4. *Set up the OutputChecker:* Tell the `OutputChecker` the addresses of the output functions that you are interested in.
5. *Input function hooking:* Use the `InputHookRegistry` to hook the input functions with a matching `InputHook`.

The ComponentAnalyser is now ready for analysis. The `analyse()` method contains the following steps:
6. *Prepare the InputTracker:* Create a new `InputTracker` for this component and loop through every possible input combination available on the bus. If the component has not been analysed before and has no expected number of inputs, the `InputTracker` will notice and allow only a single combination consisting of unconstrained inputs.
7. *Soft-reset the InputTracker.* Before running a new symbolic execution for all combinations of inputs for all entry points, the `InputTracker` needs to be soft-reset to prepare it for the new entry point.
8. *Copy the entry state* in order to avoid modifying the originally computed state.
9. *Breakpoints:* Add breakpoints to all `call` instructions and perform an output check before each call.
10. *Symbolic execution:* start a symbolic exploration from the entry state towards the output functions. If the component has no output functions, simply analyse the constraints on the inputs after stepping for a fixed number of steps.
11. *Output check:* if a `call` instruction is encountered, check whether it is calling an output function. If so, parse it using a supported `OutputParser`.
12. *Write to the bus:* Write the parsed output to the bus.


#listing(
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


#listing(
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
