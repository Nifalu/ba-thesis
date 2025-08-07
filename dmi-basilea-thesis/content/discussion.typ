#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Discussion <discussion>

In this chapter we will discuss the feedback received in the evaulation and also look at some of the limitations of the *MCS Analyser*.

== Discussion of the expert interview

The expert interview with Mischa Jahn highlighted the challenges of ensuring safety and security in larger teams where only a few people have expertise in security. The ability to automatically determine communication paths with the use of symbolic execution can be very useful. Since *MCS Analyser* aims to retrieve as much information as possible from the binary, it minimizes usage errors and can really be used to verify if the system is communicating as intended.

The expert mentioned that the tool would require some additional features to be of use in his current workflow, however this does not limit its usefulness in cases such as described above.

*Integration into existing workflow:*
In order to be useful in his current workflow the tool would have to be capable to compute probabilities of certain paths being taken and or being exploited by an attacker. This would require a more in-depth analysis of the binary to detect bugs and vulnerabilities which is partially already possible #todo-missing("insert references") and also some formula to determine the probability of a certain path being taken. The former could be achieved by extending the analysis steps MCS Analyser already performs, the latter seems also feasible as symbolic execution already provides all information needed to for a specific path. The difficulty is probably in the definition of the formula to compute the probabilities.

*Suggested improvements:*
Furthermore, simulating the possible effects of a certain communication path on the aircraft itself would help to understand the consequences of that path. One could also determine a set of states (constraints) in which the aircraft should not be in and then check if there exists a communication path that could lead to such a state. This could be achieved by simply adding a new binary that simulates the aircraft behaviour. *MCS Analyser* would automatically analyse this binary and display the resulting constraints which can be compared to some ground truth.

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

== Technical limitations

*Path explosion* is a common problem in symbolic execution. Usually the binaries for simple components like sensors or actuators are rather small and therefore the number of paths is manageable. This however is a simple excuse and *MCS Analyser* is not immune to this problem. During the exploration of the binary from the entry point to an output function, *MCS Analyser* uses an CFGEmulated in order to avoid paths that do not lead to an output function. Essentially it just traverses the graph from input to output and ignores all other paths. This dramatically improves the performance of the analysis as depending on the number of possible inputs, a single binary might be analysed many times. But, in order to get the CFGEmulated, Angr has to symbolically execute the entire binary up front. This is only done once per binary and then cached, but it will inevitably lead to path explosion issues if the binary is too complex.

*Non linear control flow* like loops or recursion produce potentially infinite paths which further promotes path explosion issues.

*Compiler options* have a significant impact on the analysis. In this demonstration all binaries are compiled with the `-O0` option which disables all optimisations which makes it easier to understand the results of the analysis. The flag `-g` is used to include debug information which for example allows *MCS Analyser* to retrieve the variable names for the message ids. This is not strictly necessary for the analysis to work but it makes the visualisation much more readable.

