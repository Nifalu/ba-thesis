#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Discussion <discussion>

In this chapter, we will discuss the feedback received during the evaluation and examine some of the limitations of the *MCS Analyser*.

== Discussion of the expert interview

The expert interview with Dr Mischa Jahn highlighted the challenges of ensuring safety and security in larger teams where only a few people have security expertise. The ability to automatically determine communication paths using symbolic execution can be incredibly useful. Since the MCS Analyser aims to retrieve as much information as possible from the binary, it minimises usage errors and can be used to verify whether the system is communicating as intended.

The expert mentioned that the tool would require additional features to be useful in his current workflow; however, this does not limit its usefulness in the above-described cases.

*Integration into existing workflow:*
In order to be useful in his current workflow the tool would need to be able to compute the probability of certain paths being taken and or being exploited by an attacker. This would require a more in-depth analysis of the binary to detect bugs and vulnerabilities, which is partially already possible #todo-missing("insert references"), as well as some formulae to determine the probability of a certain path being taken. The former could be achieved by extending the analysis steps that MCS Analyser already performs. The latter also seems feasible, since symbolic execution already provides all the necessary information for a specific path. The difficulty lies in defining the formula to compute the probabilities.

*Suggested improvements:*
Furthermore, simulating the possible effects of a certain communication path on the aircraft itself would help to understand the consequences of that path. It would also be possible to determine a set of states (constraints) that the aircraft should not be in, and then check whether a communication path could lead to such a state. This could be achieved by adding a new binary that simulates aircraft behaviour. The *MCS Analyser* would then automatically analyse this binary and display the resulting constraints, which could be compared to some ground truth.


A potential extended analysis could look like this:
#figure(
  supplement: [Figure],
  pad(scale(diagram(
    node-stroke: 1pt,
    edge((-1,1), "r", "->", label: "MCS", label-pos: 0.2),
    node((0,1), [Information Retrieval]),
    edge("r", "-|>"),
    edge("d", "-|>"),
    node((1,1), [Simulation \ incl. effects on aircraft]),
    node((0,2), [Bug Detection]),
    edge((1,1),"r", "-|>"),
    edge("r,r", "-|>"),
    node((2,1), [Visualisiation]),
    edge("d", "-|>"),
    node((2,2), [Probability Calculation]),
    edge("r", "-|>", label: "Graph", label-pos: 0.8)
    ),
  85%
  ),
  10pt,
  ),
  caption: "Sketch of a possible extension of the MCS Analyser"
)

== Technical limitations <technical-limitations>

*Path explosion* is a common problem in symbolic execution. The binaries for simple components, such as sensors or actuators, are usually rather small, so the number of paths is manageable. However, this is merely an excuse, as *MCS Analyser* is not immune to this problem. When exploring the binary from the entry point to an output function, the *MCS Analyser* uses a `CFGEmulated` to avoid paths that do not lead to an output function. It essentially just traverses the graph from input to output, ignoring all other paths. This dramatically improves the performance of the analysis, as depending on the number of possible inputs, a single binary might be analysed many times. However, to obtain the `CFGEmulated`, *Angr* must symbolically execute the entire binary at the outset. This is only done once per binary and then cached, but it will inevitably lead to path explosion issues if the binary is too complex.

*Non-linear control flow*, such as loops or recursion, produces potentially infinite paths, which promotes the issue of path explosion.

*Compiler options* have an impact on the analysis. In this demonstration, all binaries are compiled with the `-O0` option, which disables all optimisations and makes the analysis results easier to understand. The flag `-g` is used to include debugging information, which allows the MCS Analyser to retrieve variable names for message IDs, for example. While this is not strictly necessary for the analysis to work, it makes the visualisation much more readable.

*Protocol violation*: the *MCS Analyser* assumes that the components communicate according to a well-defined protocol. If this is not the case, the analyser will throw an error or warning when attempting to parse an irregular message. However, if a component sends or receives a message in an unexpected way, the analyser will most likely not simulate this scenario and therefore not detect such anomalies.

*Timings and time-based attacks:* In a real system, messages are not stored on the bus. If necessary, individual components have buffers to store incoming messages until they are processed. Sophisticated priority mechanisms such as *CSMA/CD+AMP* are usually used to avoid collisions and ensure that high-priority messages are processed first. The *MCS Analyser* does not support such mechanisms and therefore does not detect anything related to message timings or priorities.

#todo-missing("Add source to CSMA/CD+AMP")
