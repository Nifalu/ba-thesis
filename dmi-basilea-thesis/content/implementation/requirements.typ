#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

== General Requirements
For the *MCS Analyser* to work correctly, it must be aligned with the architecture and the structure of the binaries to be analysed. The *MCS Analyser* is based on the assumption that components communicate according to a well-defined protocol that matches the one introduced in @methodology.

To increase the readability and interpretability of the resulting graph, optionally:
- Compile the binaries with debug information to allow the *MCS Analyser* to retrieve the names of the message types. (#eg `Engine RPM` instead of `0x1234`)
- Disable compiler optimisations to ensure that the analysed binary is as close to the source code as possible.
