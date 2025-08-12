#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing

=== common package <common>

The common package contains a variety of utilities and functionality that is used throughout the _MCS Analyser_. The most important ones are:

==== MCSGraph
This is a singleton wrapper around the `NetworkX.MultiDiGraph` class, which makes it accessible from anywhere in the project and integrates the graph visualisation library `schnauzer`.

==== MessageTracer
This provides the tracing functionality for messages mentioned in step three of @can_simulator Since components are analysed multiple times, they regularly produce identical output even though the inputs differ. In the graph, those duplicates are eliminated, #ie the information about where the message originated from is lost. The `MessageTracer` resolves this issue by keeping track of the origin of each message without adding duplicate edges to the graph.

==== IOState
A simple container that stores a bitvector and its constraints as a single object. This simplifies the passing of input and output values between the various components.

==== IndexedSet
This is a generic set extension that generates an auto-incrementing ID for each element added to the set. This is used to automatically assign IDs to messages and components in the bus while avoiding duplicates at the same time.

#figure(caption: [Overview on the high level structure of the io module.])[
  #diagram(node-stroke: 1pt, label-size: 9pt,
    
    // left side
    node((0,0), [InputHookRegistry], name: <ior>),
    node((0,2), [InputHookBase], name: <iohb>),
    node((0,1), [ScanfHook], name: <scanfh>),

    edge(<ior>, "u", "-|>", label: [provide hooks]),
    edge(<ior>, <scanfh>, "-|>", label: [registers]),
    edge(<scanfh>, <iohb>, "-|>", label: [implements]),

    // center
    node((1,0), [InputTracker], name: <iot>),

    edge(<iot>, "u", "-|>", label: [provides \ tracking info]),
    edge(<iot>, <scanfh>, "-|>", label: [provides \ next input], bend: 20deg),

    // right side
    node((2,0), [OutputChecker], name: <ioc>),
    
    
    // right side
    node((2,1), [OutputParserRegistry], name: <iopr>),
    node((2,2), [PrintfParser], name: <printfp>),
    node((1,2), [OutputParserBase], name: <iopb>),

    edge(<ioc>, "u", "-|>", label: [provide output \ checking], label-side: right),
    edge(<iopr>, <ioc>, "-|>", label: [provide \ parser], label-side: right),
    edge(<iot>, <ioc>, "-|>", label: [provide \ used inputs], label-side: right),
    edge(<iopr>, <printfp>, "-|>", label: [registers], label-side: left),
    edge(<printfp>, <iopb>, "-|>", label: [implements])
  )
]<common-structure>
