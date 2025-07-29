#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Background <background>

This chapter provides the foundation to our work. It introduces the necessary concepts and tools used in the following chapters.

== Multi Component System <mcs>
A *Component* is an autonomous unit within a larger system. It encapsulates specific functionality and communicates with other components through well-defined interfaces.

A *Multi Component System (MCS)* consists of a set of Components that collaborate in order to reach a greater goal.

A #link("https://en.wikipedia.org/wiki/CAN_bus")[*CAN bus (Controller Area Network Bus)*]#footnote("https://en.wikipedia.org/wiki/CAN_bus") is a message-oriented communication protocol and physical network widely used in the automotive and aviation industry as well as in industrial automation. Some key properties of a CAN bus are:
- A *Multi-Master Architecture* allowing any component to communicate if the bus is idle.
- A #link("https://en.wikipedia.org/wiki/Message_passing")[*Message-Oriented Protocol*]#footnote("https://en.wikipedia.org/wiki/Message_passing") data is identified by message ids rather than component addresses. This implies that every component can receive all messages.

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
*Symbolic execution* is a analysis technique where a program is executed (or simulated) with *symbolic variables (symvar)* rather than concrete data. If the program flow branches on a certain condition, *constraints* are placed on the affected symvars and both options are taken.

In order to analyse both the true and the false branch on any given branching condition, symbolic execution stores a snapshot of all registers, memory, constraints or generally all live data that can be changed by execution in a *state*.

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

*Basic blocks* represents a straight line sequence of instructions with no branches in or out except for the entry and exit points.#footnote("https://en.wikipedia.org/wiki/Basic_block") Or in other words, if the first instruction of a basic block is executed, all following instructions will be executed in order an no other instruction comes somwhere in between.

A *Control Flow Graph (CFG)* is a visual representation of all possible program paths that might be traversed during execution. Each node represents a basic block and edges display the jumps between those blocks.
#todo-missing("Visualization of basic blocks and CFG?")

*Path explosion* something #todo-missing("find some words here")

===  Constraint Solvers and Simulation Managers

*Constraint Solvers* are used to evaluate a symbolic variable with the constraints of a given state.

*Simulation Managers* determine in which order the basic blocks (nodes) in a CFG are executed. Depending on the goal of the analysis specialised traversal or exploration techniques can be applied, often with a focus to mitigate path explosion. Simulation Managers are usually backed by Constraint Solvers in order to avoid paths which are unsatisfiable.

=== Limitations of Symbolic Execution

Symbolic Execution faces many limitations such as scalability due to path explosion, loops leading to an infinite number of paths or parallel execution being difficult to simulate using a CFG. This list can be continued with constraint solvers having difficulties to solve floating point numbers correctly and many other issues described in more detail here @symEx_challenges

== Other Analysis Techniques

=== Fuzzing
*Fuzzing* is an alternative approach in which a program is executed with arbitrary concrete input and is observed how far it executes before it crashes. While this approach is much simpler compared symbolic execution it often fails to reach much depth, only covering a small percentage of the program code.

=== Unit- and User-testing
Unit testing is the most widely used technique and is mostly based on humans hoping to catch all possible edge-cases with hand-written tests. Sometimes the users themselves are involved to "simulate" user behaviour in order to find bugs.

== Static and Dynamic analysis
In *static analysis* a program is analysed through its CFG, its dataflow or other metrics than can be retrieved statically without executing the program. Symbolic execution is a static analysis as it never executes the program.

*Dynamic analysis* on the other hand executes (parts of) a program in order to collect runtime metrics. Achieving exhausting path coverage can be challenging but can provide more meaningful results compared to static analysis.

== Analysis Tools

#link("https://angr.io/")[*Angr*]#footnote("https://angr.io/") one of the leading open-source python frameworks for binary analysis. It is primarily developed by researchers in the #link("http://seclab.cs.ucsb.edu/")[Computer Security Lab at UC Santa Barbara]#footnote("http://seclab.cs.ucsb.edu/") and #link("http://sefcom.asu.edu/")[SEFCOM at Arizona State University]#footnote("http://sefcom.asu.edu/") but has a dedicated open source community contributing to the project. It offers a variety of tools ranging from CFG recovery over a powerful symbolic execution engine to automatic exploit generation and binary hardening.

Internally it uses the #link("https://github.com/Z3Prover/z3")[*Z3 Theorem Prover*]#footnote("https://github.com/Z3Prover/z3") from Microsoft Research together with #link("https://github.com/angr/claripy")[*Claripy*]#footnote("https://github.com/angr/claripy") also developed by Angr as constraint solver. Read more about Angr in @angr1 @angr2
