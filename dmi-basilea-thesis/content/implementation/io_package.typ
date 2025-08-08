#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

=== IO Package <io>

The `IO` package provides the necessary functionality to handle various input and output functions. As seen before, the `ComponentAnalyser` uses a `InputHookRegistry`, `InputTracker`, `OutputChecker` and `OutputParser` which are all part of this package.

==== InputHookRegistry
This module contains an python abstract class `InputHookBase` which defines the basic functionality of an input hook. The idea of a function hook in general is to intercept calls to that function and execute some custom code before, after or instead of the original function. In this case, the hook should simulate reading input from various sources such as standard input, files, sockets etc. Since each of those input methods has its own way of reading input, one most likely needs to implement different hooks for each of them. This abstract class allows for easy implementation of such hooks by providing a common interface which can then be used by the `InputHookRegistry` which acts as a central registry for all input hooks. It is responsible to provide the correct hook for a given function to the `ComponentAnalyser`.

==== InputTracker
The `InputTracker` is responsible for tracking what inputs are available for a given component. Its static nature allows `InputHooks` to retrieve the next input to be used for symbolic execution from the `InputTracker`. It also keeps track of how many and which inputs have been used so far. 

==== OutputChecker
The `OutputChecker` is the equivalent of the `InputHookRegistry` but for output functions. Additionally it also provides a method to check if the called address is an output function and if so, it sends that calling state to a `OutputParser` that can parse it.

==== OutputParser
Just as with various input methods, there are also various output methods and depending on the output function, the output values might be placed in different registers or memory locations. The `OutputParserRegistry` provides similar functionality as the `InputHookRegistry` and one can implement various parsers for all kinds of output functions. The `OutputParser` is responsible for reading the actual output values from the state, collecting the corresponding constraints and returning this information in form of a `Message` which can then be written to the bus by the `ComponentAnalyser`.

