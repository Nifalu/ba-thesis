#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

== Project Structure

The _MCS Analyser_ is structured in a modular way consisting of the central classes _Coordinator_ and _ComponentAnalyser_ and three Python packages providing various functionalities.

The _Coordinator_ is the brain of the _MCS Analyser_ and orchestrates the analysis of the individual components. It primarily interacts with the _CANBus_ and the _ComponentAnalyser_. The former contains all the required functionality to simulate a CAN bus. The _ComponentAnalyser_ is responsible for analysing a single component. It uses he functionality of the _io_ module to compute the input and output values, which it then loads or stores in the _CANBus_. The _common_ module contains additonal utilities used within the project.

The figure below provides a high level view on _MCS Analyser_ and highlights the most important relationships.

#figure(caption: [Project structure of the MCS Analyser])[
  #scale(diagram(node-stroke: 1pt, label-size: 9pt,

    node(enclose: ((-0.5,2), (-2.1,3.5)), corner-radius: 5pt, label: align(top + left)[io], name: <io>),
    node((-1.7, 2.5), [`InputHook`]),
    node((-1.7, 3), [`InputTracker`]),
    node((-0.9, 2.5), [`OutputChecker`]),
    node((-0.9, 3), [`OutputParser`]),

    node(enclose: ((1,-1), (2.8,0.2)), corner-radius: 5pt, label: align(top + left)[common]),
    node((1.2, -0.5), "Config"),
    node((1.9, -0.5), "MessageTracer"),
    node((1.3, 0), "MCSGraph", name: <mcsgraph>),
    node((1.9, 0), "...", stroke: none),

    node(enclose: ((1,1), (1.8,2.8)), corner-radius: 5pt, label: align(top + left)[can_simulator], name: <cansim>),
    node((1.4,1.5), [`CANBus`], name: <canbus>),
    node((1.4,2), [`Component`]),
    node((1.4,2.5), [`Message`]),

    node((-1,-1), "main", name: <main>),
    edge(<main>,<coord>, "-|>", label: "runs", bend: 5deg),

    node((0,0), "Coordinator", name: <coord>),
    edge(<coord>,<canalyser>, "-|>", label: "coordinates", bend: -10deg),
    edge(<coord>,<cansim>, "-|>", label: "initialises", bend: -5deg, label-pos: 0.2),

    node((-1.2,0.5), [`ComponentAnalyser`], name: "canalyser"),
    edge(<canalyser>,<canbus>,"-|>", bend: -8deg, label: "writes to", label-pos: 0.2),
    edge(<canbus>,<io>, "-|>", bend: 10deg, label: [provides \ bus information], label-pos: 0.7),
    edge(<canbus>,<mcsgraph>, "-|>", bend: -80deg, label: [updates], label-pos: 0.4),


    edge(<io>, <canalyser>, "-|>", shift: 5pt, label: [provides \ functionality], label-pos:0.4),
    edge(<io>, <canalyser>, "-|>", shift: -5pt),
    edge(<io>, <canalyser>, "-|>", shift: 0pt),
    edge(<io>, <canalyser>, "-|>", shift: -10pt),
  ),
  90%,
  )
]<structure>
