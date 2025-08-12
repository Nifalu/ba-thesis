#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing, codly
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

=== IO Package <io>

The `IO` package provides the necessary functionality to handle various input and output functions. As previously mentioned, the `ComponentAnalyser` uses an `InputHookRegistry`, an `InputTracker`, an `OutputChecker` and an`OutputParser` which are all part of this package.

==== InputHookRegistry
This module contains the Python abstract class `InputHookBase`, which defines the basic functionality of an input hook. The idea of a function hook in general is to intercept calls to a function and execute some custom code before, after, or instead of the original function. In this case, the hook should simulate reading input from various sources, such as standard input, files and sockets. Since each of these input methods has its own way of reading input, it is likely that different hooks will need to be implemented for each of them. This abstract class facilitates the implementation of such hooks by providing a common interface, which is then used by the `InputHookRegistry`, acting as a central registry for all input hooks. It is responsible for providing the correct hook for a given function to the `ComponentAnalyser`.

==== InputTracker
The `InputTracker` is responsible for tracking what inputs are available for a given component. Its static nature enables `InputHooks`, implementations of the `InputHookBase` class to retrieve the next input to be used for symbolic execution from the `InputTracker`. It also keeps track of how many inputs have been used so far and which ones they are.

==== OutputChecker
The `OutputChecker` is a middle layer between the `ComponentAnalyser` and the `OutputParserRegistry`. It is responsible for checking if a given state is an call state towards an output function. If so, it retrieves the function it is calling and passes the state to an `OutputParser` that parses and returns the arguments passed to the output function. The OutputChecker then crafts a new `Message` instance from the parsed arguments and returns it to the `ComponentAnalyser`.

==== OutputParser
As with various input methods, there are also various output methods and depending on the output function, the output values may be stored in different registers or memory locations. The `OutputParserRegistry` provides similar functionality as the `InputHookRegistry`, and various parsers can be implemented for all kinds of output functions. The `OutputParserBase` defines API for `OutputParsers` similarly to the `InputHookBase`.


#figure(caption: [Structure of the `io` module.])[
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
]<io-structure>
