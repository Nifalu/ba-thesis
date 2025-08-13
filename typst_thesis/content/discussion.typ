#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, listing
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Discussion <discussion>

In this chapter, we will discuss the feedback received during the evaluation and examine some of the limitations of the _MCS Analyser_.

== Discussion of the expert interview

The expert interview with Dr Mischa Jahn highlighted the challenges of ensuring safety and security in larger teams where only a few people have security expertise. The ability to automatically determine communication paths using symbolic execution can be incredibly useful. Since the _MCS Analyser_ aims to retrieve as much information as possible from the binary, it minimises usage errors and can be used to verify whether the system is communicating as intended.

The expert mentioned that the tool would require additional features to be useful in his current workflow; however, this does not limit its usefulness in the above-described cases.

- *Integration into existing workflow:* In order to be useful in his current workflow the tool would need to be able to compute the probability of certain paths being taken and or being exploited by an attacker. This would require a more in-depth analysis of the binary to detect bugs and vulnerabilities, which is partially already possible#footnote("https://docs.angr.io/en/latest/examples.html#vulnerability-discovery") @angr3 @angr4 @angr5, as well as some formula to determine the probability of a certain path being taken. The former could be achieved by extending the analysis steps that _MCS Analyser_ already performs. The latter also seems feasible, since symbolic execution already provides all the necessary information for a specific path. One just has to define the formula to compute the probabilities.

- *Suggested improvements:* Furthermore, simulating the possible effects of a certain communication path on the aircraft itself would help to understand the consequences of that path. It would also be possible to determine a set of states (constraints) that the aircraft should not be in, and then check whether a communication path could lead to such a state. This could be achieved by adding a new binary that simulates aircraft behaviour. The _MCS Analyser_ would then automatically analyse this binary and display the resulting constraints, which could be compared to some ground truth.


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

== Significance of the graph visualisation. <graph-discussion>

Storing the communication paths in a graph structure makes sense because it allows for a intuitive way of representing the real world objects and their relationships in code. Visualising the graph for the user is a natural next step as it often helps to understand complex relationships and dependencies, in this case, communication paths more easily. 

  #columns(2)[
    #figure(
      image("../img/tracing-a.png", width:100%),
      caption: [Navigation System Output _A_ with origin traces]
    ) <fig:tracing-a>
  #colbreak()
    #figure(
      image("../img/tracing-b.png", width:100%),
      caption: [Navigation System Output _B_ with origin traces]
    ) <fig:tracing-b>
  ]

_Schnauzer_ provides an interactive way to explore the graph, allowing users to simply click on edges to highlight the origin of a message. Other features include the search for specific attributes, nodes, edges and the ability to hide the communication paths produced by running components with unconstrained inputs. This is particularly useful to check whether a component would communicate differently if previous components were malfunctioning, providing unconstrained or at least unexpected inputs.

As discussed in the expert interview, the visualisation allows user to see how the actual instead of the intended communication paths. Someone could question if the _Terrain Warning System_ should really be doing its calculations based on the _Airspeed_ or if someone made a typo and it should actually be using the _Altitude_ instead.

#figure(
  image("../img/terrain.png", width:70%),
  caption: [Detecting Programming Errors.]
) <fig:terrain>


The visualisation can also be used to detect potential single points of failure, such as the _MCAS_ controlling the trim (hydraulics) based solely on the _Angle of Attack_ sensor. The example provided in this thesis might not be ideal to highlight this, but generally speaking, such a visualisation can be very helpful to understand based on which inputs a certain action can be performed.

#figure(
  image("../img/tracing-closeup.png", width:70%),
  caption: [Detecting potential single points of failure.]
) <fig:closeup>

By analysing the actual constraints on the communication paths (displayed in the sidebar), one could theoretically also determine whether a component is communicating as intended. However those constraints are usually not very readable for humans. This is where a simulator could help, simulating the effects of those constraints on the aircraft, essentially translating the constraints into a more human-readable form.

== Technical limitations <technical-limitations>

The _MCS Analyser_ provides a solid foundation for analysing the communication paths in MCSs. There are a number of limitations that need to be considered when using the tool:

- *Path explosion* is a common problem in symbolic execution. The binaries for simple components, such as sensors or actuators, are usually rather small, so the number of paths is manageable. However, this is merely an excuse, as _MCS Analyser_ is not immune to this problem. When exploring the binary from the entry point to an output function, the _MCS Analyser_ uses a `CFGEmulated` to avoid paths that do not lead to an output function. It essentially just traverses the graph from input to output, ignoring all other paths. This dramatically improves the performance of the analysis, as depending on the number of possible inputs, a single binary might be analysed many times. However, to obtain the `CFGEmulated`, angr must symbolically execute the entire binary. This is only done once per binary and then cached, but it will inevitably lead to path explosion issues if the binary is too complex.

- *Non-linear control flow*, such as loops or recursion, produces potentially infinite paths, which promotes the issue of path explosion.

- *Compiler options* have an impact on the analysis. In this demonstration, all binaries are compiled with the `-O0` option, which disables all optimisations and makes the analysis results easier to understand. The flag `-g` is used to include debugging information, which allows the _MCS Analyser_ to retrieve variable names for message IDs, for example. While this is not strictly necessary for the analysis to work, it makes the visualisation much more readable.

- *Protocol violation*: the _MCS Analyser_ assumes that the components communicate according to a well-defined protocol. If this is not the case, the analyser will throw an error or warning when attempting to parse an irregular message. However, if a component sends or receives a message in an unexpected way, the analyser will most likely not simulate this scenario and therefore not detect such anomalies.

- *Timings and time-based attacks:* In a real system, messages are not stored on the bus. If necessary, individual components have buffers to store incoming messages until they are processed. Sophisticated priority mechanisms such as _CSMA/CR_ @csma1 @csma2 are usually used to detect, avoid or resolve collisions and ensure that high-priority messages are processed first. The _MCS Analyser_ does not support such mechanisms and therefore does not detect anything related to message timings or priorities.
