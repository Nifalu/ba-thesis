#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

== Requirements
In order for the *MCS Analyser* to work correctly, it has to be aligned to the architecture and the structure of the binaries it should analyse. The implementation of the *MCS Analyser* is based on the assumption that the components communicate according to a well-defined protocol.

Optionally, for better readability and interpretability of the resulting graph the following is recommended:
- The binaries are compiled with debug information, allowing the *MCS Analyser* to retrieve variable names of the messages types. (#eg "Engine RPM" instead of `0x1234`)
- Compiler optimisations are disabled, ensuring that the analysed binary is as close to the source code as possible.
