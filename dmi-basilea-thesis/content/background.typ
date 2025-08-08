#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Background <background>

This chapter provides the foundation for our work. It introduces the necessary concepts and tools that will be used in the following chapters.

== Multi-Component System (MCS) <mcs>

A *Component* is an autonomous unit within a larger system. It encapsulates specific functionality and communicates with other components through well-defined interfaces.

A *Multi-Component System (MCS)* is a set of components that work together to achieve a greater goal. The components are all part of a single structural unit, which differentiates MCSs from distributed systems, which may also include systems where components are geographically separated.

A #link("https://en.wikipedia.org/wiki/CAN_bus")[*CAN bus (Controller Area Network Bus)*]#footnote("https://en.wikipedia.org/wiki/CAN_bus") is a message-oriented communication protocol and physical network that is widely used in the automotive and aviation industries, as well as in industrial automation. Some key properties of a CAN bus are:
- A *Multi-Master Architecture*, allowing anyone to communicate at any time without a central control instance. More on this in @discussion
- A #link("https://en.wikipedia.org/wiki/Message_passing")[*Message-Oriented Protocol*]#footnote("https://en.wikipedia.org/wiki/Message_passing"), where data is identified by message IDs rather than a source or destination addresses. This implies that everyone receives all messages.

#figure(
  supplement: [Figure],
  pad(scale(diagram(
    node-stroke: 1pt,
    node((0,0), [Engine RPM]),
    edge("d", "-"),
    node((1,0), [Forward Radar]),
    edge("d", "-"),
    node((2,0), [Navigation Unit]),
    edge("d", "-"),
    edge((-1, 1), "r,r,r,r", "-", label: "bus", label-pos: 0.1),
    ),
  95%
  ),
  10pt,
  ),
  caption: "Architecture of a Controller Area Network Bus"
)

== Symbolic Execution
*Symbolic execution* is an analysis technique in which a program is executed#footnote([technically it is simulated, but it is still called symbolic _execution_]) with *symbolic variables (symvar)* rather than concrete data. If the program flow branches on a certain condition, *constraints* are placed on the affected symbolic variables and both options are taken.

To order to analyse both the true and the false branches of a given branching condition, symbolic execution stores a snapshot of all registers, memory, constraints, and all other live data that can be changed by execution in a *state*. As each instruction updates the instruction pointer, a new state is created for each instruction executed.

#figure(
  supplement: [Example],
  columns(2)[
    #scale(75%)[#diagram(
    node-stroke: 1pt,
    node((-1,0), [main]),
    edge("-|>"),
    node((0,0), [scanf]),
    edge("-|>"),
    node((0,1), [input > 10], shape: shapes.diamond),
    edge("d,d", "-|>", `[symvar <= 10]`, label-pos: 0.5, label-side: left),
    edge("l,d", "-|>", `[symvar > 10]`, label-pos: 0.5),
    node((-1,2), [prinf]),
    node((0,3), [input == 42], shape: shapes.diamond),
    edge("l,d", "-|>", `[symvar <= 10]`, label-pos: 0.5),
    edge("d", "-|>", [`[symvar <= 10 &&`\ `symvar == 42]`], label-pos: 0.5, label-side: left),
    node((-1,4), [prinf]),
    node((0,4), [prinf], fill: red),
    )
  ]
  #colbreak()
    #v(2em)
    ```C
    int main() {
      uint64_t input
      scanf("%lu", &input)
      if (input > 10)
        printf("Hello")
      else
        if (input == 42)
          printf("Suspicous")
        else
          printf("World")
      return 0
    ```
  ],
caption: "Simple Symbolic Execution Example"
)

*Basic blocks* represent a straight line sequence of instructions with no branches in or out except for the entry and exit points#footnote("https://en.wikipedia.org/wiki/Basic_block"). In other words, if the first instruction of a basic block is executed, then all the following instructions will be executed in order and no other instruction will come in between them.

A *Control Flow Graph (CFG)* is a visual representation of all possible program paths that might be traversed during execution. Each node represents a basic block and edges display the jumps between those blocks.
#todo-missing("Should we add a figure here?")

*Path explosion* describes the exponential growth of the number of paths in a CFG as the number of branching conditions increases.

===  Constraint Solvers and Simulation Managers

*Constraint solvers* evaluate a symbolic variable with the constraints of a given state.

*Simulation Managers* determine the execution order of the basic blocks (nodes) in a CFG. Depending on the analysis goal, specialised traversal or exploration techniques can be applied, often with a focus on mitigating path explosion. Simulation managers are usually backed by constraint solvers in order to avoid unsatisfiable paths.

=== Limitations of Symbolic Execution

Symbolic execution faces many limitations, such as scalability due to path explosion, loops leading to an infinite number of paths, and the difficulty of simulating parallel execution using a CFG. Other limitations include constraint solvers having difficulty solving floating-point numbers correctly, and many other issues described in more detail here: @symEx_challenges

== Other Analysis Techniques

=== Fuzzing
*Fuzzing* is an alternative approach in which a program is executed with arbitrary concrete input, and how far it executes before crashing is observed. While this approach is much simpler than symbolic execution, it often fails to reach much depth and only covers a small percentage of the program code.

=== Unit- and User-testing
*Unit testing* is the most widely used technique, mostly relying on humans to identify all possible edge cases through manual testing. If users are involved in simulating user behaviour to find bugs, it is called *user testing*. In both cases, exhaustive coverage of all possible program paths is difficult to achieve.

== Static and Dynamic analysis
In *static analysis*, a program is analysed through its CFG, data flow, or other metrics that can be retrieved statically without executing the program. Symbolic execution is a form of static analysis, as it technically never executes the program, but rather simulates it.

*Dynamic analysis*, on the other hand, involves executing (parts of) a program to collect runtime metrics. While challenging, achieving exhaustive path coverage can provide more meaningful results than static analysis.

== Analysis Tools

#link("https://angr.io/")[*Angr*]#footnote("https://angr.io/") is one of the leading open-source Python frameworks for binary analysis. It is primarily developed by researchers at the #link("http://seclab.cs.ucsb.edu/")[Computer Security Lab at UC Santa Barbara]#footnote("http://seclab.cs.ucsb.edu/") and #link("http://sefcom.asu.edu/")[SEFCOM at Arizona State University]#footnote("http://sefcom.asu.edu/"), but has a dedicated open source community contributing to the project. It offers a variety of tools, ranging from CFG recovery over a powerful symbolic execution engine, to automatic exploit generation, and binary hardening.

It uses the #link("https://github.com/Z3Prover/z3")[*Z3 Theorem Prover*]#footnote("https://github.com/Z3Prover/z3") from Microsoft Research, together with #link("https://github.com/angr/claripy")[*Claripy*]#footnote("https://github.com/angr/claripy") also developed by Angr, as a constraint solver. Read more about Angr in @angr1 @angr2

#link("https://triton-library.github.io/")[*Triton*]#footnote("https://triton-library.github.io/") is an alternative binary analysis framework written in C++ and is published under the Apache 2.0 licence.
