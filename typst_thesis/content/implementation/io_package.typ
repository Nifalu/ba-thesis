#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

=== IO Package <io>

The `IO` package provides the necessary functionality to handle various input and output functions. As previously mentioned, the `ComponentAnalyser` uses an `InputHookRegistry`, an `InputTracker`, an `OutputChecker` and an`OutputParser` which are all part of this package.

==== InputHookRegistry
This module contains the Python abstract class `InputHookBase`, which defines the basic functionality of an input hook. The idea of a function hook in general is to intercept calls to a function and execute some custom code before, after, or instead of the original function. In this case, the hook should simulate reading input from various sources, such as standard input, files and sockets. Since each of these input methods has its own way of reading input, it is likely that different hooks will need to be implemented for each of them. This abstract class facilitates the implementation of such hooks by providing a common interface, which is then used by the `InputHookRegistry`, acting as a central registry for all input hooks. It is responsible for providing the correct hook for a given function to the `ComponentAnalyser`.

==== InputTracker
The `InputTracker` is responsible for tracking what inputs are available for a given component. Its static nature enables `InputHooks` to retrieve the next input to be used for symbolic execution from the `InputTracker`. It also keeps track of how many inputs have been used so far and which ones they are.

==== OutputChecker
The `OutputChecker` is the equivalent of the `InputHookRegistry`, but for output functions. It also provides a method to check whether the called address is an output function, in which case it sends the calling state to an `OutputParser` that can parse it.

==== OutputParser
As with various input methods, there are also various output methods and depending on the output function, the output values may be stored in different registers or memory locations. The `OutputParserRegistry` provides similar functionality as the `InputHookRegistry`, and various parsers can be implemented for all kinds of output functions. The `OutputParser` is responsible for reading the actual output values from the state, collecting the corresponding constraints and returning this information in the form of a `Message`, which the `ComponentAnalyser` can then write to the bus.
