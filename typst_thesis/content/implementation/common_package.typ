#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes


=== Common package <common>

The common package contains a variety of utilities and functionality that is used throughout the _MCS Analyser_.

#figure(caption: [Structure of the `common` module.])[
  #diagram(node-stroke: 1pt, label-size: 9pt,
    
    node((0,0), [MCSGraph], name: <mcsgraph>),
    node((1,0), [MessageTracer], name: <messagetracer>),
    node((2,0), [IOState], name: <iostate>),
    node((3,0), [IndexedSet], name: <indexedset>),
    node((0.5,0.6), [Config], name: <config>),
    node((1.5,0.6), [Utils], name: <utils>),
    node((2.5,0.6), [Logger], name: <logger>),

    edge(<mcsgraph>, "u", "-|>", label: [provides \ the graph]),
    edge(<messagetracer>, "u", "-|>", label: [tracks message \ origins], label-side: right),
    edge(<iostate>, "u", "-|>", label: [stores symbolic \ expressions], label-side: right),
    edge(<indexedset>, "u", "-|>", label: [provides auto \ incrementing IDs]),

    edge(<config>, "d", "-|>", label: [stores \ configuration], label-side: left),
    edge(<utils>, "d", "-|>", label: [extract \ message IDs], label-side: left),
    edge(<logger>, "d", "-|>", label: [easier \ debugging], label-side: left),
  )
]<common-structure>

==== MCSGraph
This is a singleton wrapper around the `NetworkX.MultiDiGraph` class, which makes it accessible from anywhere in the project and integrates the graph visualisation library `schnauzer`.

==== MessageTracer
This provides the tracing functionality for messages mentioned in step three of @can_simulator Since components are analysed multiple times, they regularly produce identical output even though the inputs differ. In the graph, those duplicates are eliminated, #ie the information about where the message originated from is lost. The `MessageTracer` resolves this issue by keeping track of the origin of each message without adding duplicate edges to the graph.

==== IOState
A simple container that stores a bitvector and its constraints as a single object. This simplifies the passing of input and output values between the various components.

==== IndexedSet
This is a generic set extension that generates an auto-incrementing ID for each element added to the set. This is used to automatically assign IDs to messages and components in the bus while avoiding duplicates at the same time.


