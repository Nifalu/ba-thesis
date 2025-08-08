#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

=== common package <common>

The common package holds a variety of utilities and functionality that is used throughout the *MCS Analyser*. The most important ones are:

==== MCSGraph
A singleton wrapper around the `NetworkX.MultiDiGraph` class to make it accessible from anywhere in the project and to integrate the graph visualisation library `schnauzer`.

==== MessageTracer
Provides the tracing functionality for messages mentioned in step three of @can_simulator Since components are analysed multiple times, they regularly produce identical output even though the inputs differ. In the graph those duplicates are eliminated, i.e the information of where the message originated from is lost. The `MessageTracer` resolves this by keeping track of the origins or each message without flooding the graph with identical edges.

==== IOState
A simple container to store a bitvector and its constraints as a single object. This simplifies the passing of input and output values between the various components.

==== IndexedSet
A generic set extension that generates an auto-incrementing id for each element added to the set. This is used to automatically assign ids to messages and components in the bus, keeping the uniqueness of a set while also allowing for easy access to elements by their id.
