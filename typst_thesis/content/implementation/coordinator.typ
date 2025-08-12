#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing, codly

=== The Coordinator

The _Coordinator_ is the entry point of the _MCS Analyser_. Before that, there is only _main_, which is responsible for parsing command line arguments and starting the coordinator.

The _Coordinator_ is responsible for the overall flow of the analysis, which takes place in three phases, as described in @phase1. Here a phase 0 is added which initialises and prepares the different classes.

- *Phase 0:* The _Coordinator_ starts by initialising the _CANBus_. See @im-canbus

- *Phase I*: Symbolically execute all components and provide unconstrained input. Observe and retrieve the constraints placed in those inputs to retrieve information on what the component will consume. Similarly with what it will produce. The algorithm in @th-analysing-loop can be improved by caching the _ComponentAnalyser_ instances and retrieving the input/ouput addresses, entry states, the CFG and the angr project only once per component. Last, components that consume only one message are marked as _analysed_ immediately. They don't follow the bus protocol in how they consume messages and are theerfore seen as producers of messages (#eg a sensor reading measurements and sending them to the bus).

#listing(caption: [Simplified view of phase I of the `Coordinator`])[
  #codly(highlights:(
    (line: 2, start: 3, end: 20),
    (line: 5, start: 5, end: 40),
  ))
    ```python
    with CANBus as bus:
      analyser_dict = {} # analyser cache
      for component in bus.components:
        mcsa = ComponentAnalyser(component)
        analyser_dict[component.name] = mcsa
        mcsa.analyse()
        if not component.consumed_ids:
          component._is_analysed = True
    ```
]

As seen in @structure and looked at in more detail in @canalyser, the _ComponentAnalyser_ directly updates the _CANBus_ whenever it found a new message. Therefore by just running the _ComponentAnalyser_ in the first phase, the _CANBus_ is already populated with all messages that were produced by the components given unconstrained inputs.

- *Phase II*: Symbolically execute all components which are not marked as _analysed_ a second time. This time with the inputs available in the _CANBus_. The `analyse()` method will set components as _not analysed_ if they can consume a message that was just produced. Therefore, components can potentially be analysed many times before the algorithm terminates. Note that the `generate_input_combination()` function @th-analysing-loop is moved inside the `analyse()` method.

#listing(caption: [Simplified view of phase II of the `Coordinator`])[
  ```python
    while True:
      made_progress = False
      for c in bus.components:
        if not c.is_analysed and can_analyse(c, bus):
          mcsa = analyser_cache[c.name]
          mcsa.analyse()
          c.is_analysed = True
          made_progress = True
          if not made_progress:
            break

    def can_analyse(c, bus):
      # The bus should have enough msgs of the types the component consumes
      if c.max_expected_inputs // 2 > bus.num_msgs_of_types(c.consumed_ids):
        # divide by 2 because one message holds two inputs (id and data)
        return False
      return True
    ```
]


- *Phase III*: The _MCSGraph_ is already populated with nodes and edges during the first two phases. In this phase, the _MCSGraph_ is finalised by adding colors for the different component and message types. Then the _MCSGraph_ is visualised using the _schnauzer_ library.
