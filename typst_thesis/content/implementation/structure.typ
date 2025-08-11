#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

== Project Structure:

The _MCS Analyser_ is structured in a modular way and consists of 5 main parts:

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

The `Coordinator` is the brain of the _MCS Analyser_ and orchestrates the analysis of the individual components. It primarily interacts with the `can_simulator` and the `ComponentAnalyser`. The former is a Python package that contains all the required functionality to simulate a CAN bus#footnote("In python terminology a package is a directory while a module is a single file."). The `ComponentAnalyser` is responsible for analysing a single component. It uses he functionality of the `io` module to compute the input and output values, which it then loads or stores via the `can_simulator`. The `common` module contains additonal utilities used within the project. Let's take a closer look at how the _MCS Analyser_ works in detail.
