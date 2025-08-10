#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

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
