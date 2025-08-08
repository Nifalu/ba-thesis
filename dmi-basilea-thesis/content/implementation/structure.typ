#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

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
