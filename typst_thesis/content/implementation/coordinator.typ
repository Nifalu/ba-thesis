#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing

=== The Coordinator

The `Coordinator` is the entry point of the _MCS Analyser_. Before that, there is only `main.py`, which is responsible for parsing command line arguments and starting the coordinator.

The `Coordinator` is responsible for the overall flow of the analysis, which takes place in three phases, as discussed earlier.

- *Phase I*: Use the `can_simulator` to initialise the CAN bus and analyse all components with unconstrained inputs in order to retrieve information. (See @phase1)

- *Phase II*: Analyse the components using the `ComponentAnalyser`, ensuring that all required messages are available before starting the analysis.

- *Phase III*: Use the `schnauzer` library to enrich the graph initially built by the `can_simulator` with information necessary for the visualisation and display it.

#listing(
  ```python
  class Coordinator:
    def run(config):
      # Phase I
      with CANBus() as bus: # This initialises the CAN bus
        analyser_cache = {}
        for c in bus.components:
          analyser = ComponentAnalyser(c)
          analyser_cache[c.name] = analyser
          analyser.analyse()
        for c in bus.components:
          if not c.consumed_ids:
            c.is_analysed = True

        # Phase II
        while True:
          made_progress = False
          for c in bus.components:
            if not c.is_analysed and can_analyse(c, bus):
              analyser = analyser_cache[c.name]
              analyser.analyse()
              c.is_analysed = True
              made_progress = True
          if not made_progress:
            break

        # Phase III
        MCSGraph.visualise()

    def can_analyse(c, bus):
      # The bus should have enough msgs of the types the component consumes
      if c.max_expected_inputs // 2 > bus.num_msgs_of_types(c.consumed_ids):
        # divide by 2 because one message holds two inputs (id and data)
        return False
      return True
    ```,
  caption: [Simplified view of the `Coordinator` class]
)
