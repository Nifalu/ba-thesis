#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
= Implementation <implementation>

#todo-missing("How do we name the tool??")

This chapter focuses on the practical implementation of the previously introduced approach to analyse a Multi Component System. We developed a tool called *MCSAnalyser* #todo-missing("Insert Github link") which uses the binary analysis platform #link("https://angr.io/")[*angr*] for the analysis part as well as a self-written visualisation library #link("https://github.com/Nifalu/schnauzer")[*Schnauzer*]#footnote("https://github.com/Nifalu/schnauzer") to display the resulting graph in a interactive way. *MCSAnalyser* is public, open-source and with expandablity in mind. Informations for developers who want to contribute can be found in the README.

#todo-missing("Write README (or wiki??) - Also fix mono font size D:")

The tool was developed with minimal human input in mind to reduce the chance of misleading outputs caused by usage-errors. Correspondingly simple is the usage:

1. Prepare a *`config.json`* that contains information on which input and output functions to track, the directory containing the component binaries as well as the individual components with some optional metadata for visualisation purposes.
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
```

#todo-missing("Make name and description optional in the code")

2. Run the *MCS Analyser*: `python main.py --config <config.json>`
3. View the resulting graph on `http://localhost:8080`

#todo-missing("Those descriptions should match the documentation comments and the README")
== Project Structure:
- *coordinator.py* coordinates the entire analysis.
- *can_simulation* encapsulates logic to simulate a canbus.
- *mcsanalyser.py* holds the main analysis logic
- *input* module holds logic to generate and track symbolic input
- *output* module holds logic to parse output.

#todo-missing("Organize the code better")

#figure(
  supplement: [Figure],
  pad(scale(diagram(
    node-stroke: 1pt,
    edge((-1,1), "r", "->", label: "main", label-pos: 0.2),
    node((0,1), [Coordinator]),
    edge("d", "-|>"),
    edge("r", "<|-|>"),
    node((1,1), [MCSAnalyser]),
    edge("u", "<|-|>"),
    edge("r", "<|-|>"),
    edge("d", "<|-|>"),
    edge("dl", "<|-|>"),
    node((0,2), [canbus]),
    node((1,0), [InputHookRegistry]),
    node((2,1), [InputTracker]),
    node((1,2), [OutputChecker]),
    edge("r", "<|-|>"),
    node((2,2), [OutputParser]),
  ),
  95%
  ),
  10pt,
  ),
  caption: "High level overview of the MCS Analyser"
)

== How it works:
=== The Coordinator
The `Coordinator` essentially guides the analysis through the three phases described in @methodology.

In a first phase the coordinator reads the config file and initialises the `canbus`. Each component specified in the config is analysed by the `MCSAnalyser` to retrieve basic information about the system. (Phase I: @phase1)

During this analysis the following information is stored in the `components` within the `canbus`:
- The maximum number of inputs a component will ever read.
- The message types a component will accept.
- The message types a component will produce.

It follows the second phase:
The coordinator marks all components that subscribe to no message id as "analysed". It then loops through all components until everything is analysed. The `_can_analyse()` function checks if enough messages of the subscribed types of a component are available in the buffer. If so, the component can be analysed. Else, another component has to produce the missing message types first.

```python
def _can_analyse(cls, c, bus) -> bool:
    if c.max_expected_inputs // 2 > bus.number_of_msgs_of_types(c.subscriptions):
        return False
    return True
```
#todo-missing("Ensure this code is still valid.")

=== The MCSAnalyser
#todo-missing("Explain how an analysis of a single component works")

==== Input generation
#todo-missing("How an unconstrained bitvector is created or how input combinations are generated and passed in as input")

==== Output parsing
#todo-missing("How the correct variable is retrieved from the output function and how it is linked to its input.")

=== Visualisation
#todo-missing("How we enrich the graph already used by angr and pass it to schnauzer")
