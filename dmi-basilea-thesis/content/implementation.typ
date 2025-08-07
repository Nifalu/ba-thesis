#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
= Implementation <implementation>

This chapter focuses on the practical implementation of the previously introduced approach to analyse a Multi Component System. We developed a tool called *MCS Analyser* #todo-missing("Insert Github link") which uses the binary analysis platform #link("https://angr.io/")[*angr*] for the analysis part as well as a self-written visualisation library #link("https://github.com/Nifalu/schnauzer")[*Schnauzer*]#footnote("https://github.com/Nifalu/schnauzer") to display the resulting graph in a interactive way. *MCS Analyser* is public, open-source and with expandablity in mind. Information for developers who want to contribute can be found in the `README`.

#todo-missing("Write and link README")


== Requirements
In order for the *MCS Analyser* to work correctly, it has to be aligned to the architecture and the structure of the binaries it should analyse. The implementation of the *MCS Analyser* is based on the assumption that the components communicate according to a well-defined protocol.

Optionally, for better readability and interpretability of the resulting graph the following is recommended:
- The binaries are compiled with debug information, allowing the *MCS Analyser* to retrieve variable names of the messages types. (#eg "Engine RPM" instead of `0x1234`)
- Compiler optimisations are disabled, ensuring that the analysed binary is as close to the source code as possible.


== Usage

The tool was developed with minimal human input in mind to reduce the chance of misleading outputs caused by usage-errors. Correspondingly simple is the usage:

*Prerequisites:* Clone the repository and install make sure to have a working Python environment with the packages listed in the `requirements.txt` installed. The tool was developed and tested with Python 3.13.

*Steps to run the MCS Analyser:*
1. Prepare a *`config.json`* that contains information on which input and output functions to track, the directory in which the component binaries are located as well as the binary filename of each component. Optionally a name and description can be provided which greatly increases the readability of the resulting graph.

2. Run the *MCS Analyser* with the following command:
```bash
python main.py --config <config.json>
```

3. View the resulting graph on #link("http://localhost:8080")[`http://localhost:8080`]

#figure(pad(
```json
{
  "var_length": 64,
  "input_hooks": ["scanf"],
  "output_hooks": ["printf"],
  "components_dir": "./bin/cesna",
  "components": [
    {
      "name": "Speed Sensor",
      "filename": "c1_speed_sensor",
      "description": "Produces speed readings"
    }
  ]
}
```,
  10pt),
  caption: "Example configuration file for the MCS Analyser"
)

#todo-missing("Create some better design for code blocks")
#todo-missing("Decide how to handle the schnauzer visualisation...")


== Project Structure:

The *MCS Analyser* is structured in a modular way and consists of 5 main parts:

#figure(
  supplement: [Figure],
  pad(scale(diagram(
    node-stroke: 1pt,

    node((0,0.5),
      [can_simulator],
      width: 3cm,
      height: 2cm,
      fill: none,
      stroke: 1pt + gray,
      corner-radius: 5pt,
    ),

    node((1,0.5),
      [io],
      width: 3cm,
      height: 2cm,
      fill: none,
      stroke: 1pt + gray,
      corner-radius: 5pt
    ),

    node((2,0.5),
      [common],
      width: 3cm,
      height: 2cm,
      fill: none,
      stroke: 1pt + gray,
      corner-radius: 5pt
    ),
    node((0.5,1.5), [Coordinator]),
    node((1.5,1.5), [ComponentAnalyser]),
  ),
  95%
),
  10pt,
  ),
  caption: "Project structure of the MCS Analyser"
)

The `Coordinator` is the brain of the *MCS Analyser* and orchestrates the analysis of the individual components. It mainly interacts with the `can_simulator` and the `ComponentAnalyser`. The former is a python package#footnote("In python terminology a package is a directory while a module is a single file.") that contains all the required functionality to simulate a CAN bus. The `ComponentAnalyser` is responsible for the analysis of a single component. It uses functionality from the `io` module to compute the input and output values and loads or stores them via the `can_simulator`. The `common` module contains additonal utilities used within the project. We will now take a closer look at the internals of the *MCS Analyser*.

== How it works

=== The Coordinator

The `Coordinator` is the entry point of the *MCS Analyser*. Before it comes only `main.py` which is responsible for parsing command line arguments and starting the coordinator.

It is responsible for the overall flow of the analysis and does that in the three phases discussed earlier.

- Phase I: Use the `can_simulator` to initialise the CAN bus and prepare the components for analysis. This includes an initial unconstrained run but we will cover that in more detail in @can_simulator

- Phase II: Analyse the components using the `ComponentAnalyser`, ensuring that all required messages are available before starting an analysis.

- Phase III: Enrich the graph initially built by the `can_simulator` with information necessary for the visualisation and display it using the `schnauzer` library.

#algorithm(
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
  caption: "Simplified view of the Coordinator class"
)

=== can_simulator Package <can_simulator>
The `can_simulator` package contains functionality to simulate and model CAN bus communication. It differs from real Controller Area Networks in that messages remain in the bus indefinitely. Read more about the effects of this in @technical-limitations

==== CANBus
#todo-missing("level 4 headings need to be smaller than levle 3 headings lol")
The `CANBus` core of the `can_simulator` package and represents the simulated CAN bus. During initialisation it reads the configuration file, prepares the components extracts the variable names for the message ids in order to display more readable names later.

Its main function is the `write()` function which is used to write messages to the bus. It takes the `produced_msg`, the new message that should be written to the bus, and a list of `consumed_msgs`, the messages that were used to produce the new message, as parameters. It then performs a series of steps, updating various flags and lists and eventually adds the message to the bus.

1. Throw a warning and return if the message type of the produced message is symbolic. Messages of any kind must always have a concrete type.
2. Check if the produced message is already in the bus and add it if not the case. Since each component is analysed multiple times, there is a high chance of duplicate messages which we dont need to add again.
3. Create a new `production` object to store the origins of the produced message, needed for message tracing later. Even though we do not want to display the same message twice in the graph, this same message might be produced by different inputs. Therefore we still need to ttrack where the message originated from.
4. If it is a new message, (#ie not already in the bus), we update a list keeping track of how many messages of each type are currently in the bus. This is used to determine if a component can be analysed or not. We also need to check if any previously analysed component can consume this message and if so, set its `is_analysed` flag to `False`.
5. Finally we update the graph, drawing edges from the sources of the consumed messages to the source of the produced message, #ie this component.

#todo-missing("Add code snipped for the write function")

=== ComponentAnalyser

=== IO Package <io>

==== Input hooks

==== Input tracking

==== Output checker

==== output parsing

=== common package <common>
#todo-missing("Is this relevant enough to be its own section?")

=== MCSGraph <mcsgraph>

=== Schnauzer Visualisation Library <schnauzer>
