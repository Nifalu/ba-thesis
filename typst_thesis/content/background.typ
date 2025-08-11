#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Background <background>

This chapter provides the foundation for our work. It introduces the necessary concepts and tools that will be used in the following chapters.

== Multi-Component System (MCS) <mcs>

In the automotive and aviation industry but also in industrial automations, system (#eg an airplane, train, car or letter sorting machine) consists of dozens of individual sensors, actuators, small compute units and other components all working together in order to make the system itself functional.

#definition(
  [A *Component* is an autonomous unit within a larger system. It encapsulates specific functionality and communicates with other components through well-defined interfaces.]
)

#definition(
  [A *Multi-Component System (MCS)* is a set of components that work together to achieve a greater goal.]
)

The components are all part of a single structural unit, which differentiates MCSs from distributed systems, which may also include systems where components are geographically separated.

#definition(
  [A *CAN (Controller Area Network)* @canclassic @canfd is a message-oriented communication protocol and physical network that is widely used in the automotive and aviation industries, as well as in industrial automation.]
)

In this thesis, a MCS is always meant to be based on a CAN. Therefore communications within a MCS can be understood as communications within a CAN.

#pad(figure(
  supplement: [Figure],
  scale(diagram(
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
  caption: "Architecture of a Controller Area Network Bus"
),
10pt,
)
In CAN, all components (usually controllers and actuators) communicate over a single bus with no central control unit in place. Message collisions are resolved using a _Carrier Sense Multiple Access / Collision Resolution_ (CSMA/CR) procedure. Read more about CAN in @canhistory and the CSMA procedure in @csma1 and @csma2

== Symbolic Execution
*Symbolic Execution* is an analysis technique in which a program is executed with symbolic variables rather than concrete data. If the program flow branches on a certain condition, constraints are placed on the affected symbolic variables and both options are taken.

#definition(
  [A *Symbolic Variable (symvar)* represents a mathematical symbol rather than a numerical value. It is used in symbolic execution, where the variable represents an unknown quantity and allows for algebraic manipulations and reasoning about expressions rather than just numerical calculations.]
)

#definition(
  [*Constraints* are a set of boolean expressions, equations or inequalities restricting referenced symbolic variables to specific ranges, values or relationships with other variables.]
)

In order to analyse both branches of a given condition, symbolic execution stores a snapshot of all registers, memory, constraints, and all other live data that can be changed by execution in a state. As each instruction updates the instruction pointer, a new state is created for each instruction executed.

#definition(
  [A *State* represents the programs current position including all symbolic variables and their values and constraints at a specfic point during execution.]
)

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
caption: "Simple Symbolic Execution"
)

Even though it is called symbolic _execution_, it is actually more a simulation of the program. The following concepts show how symbolic execution engines divide a program into smaller pieces and how control flow graphs are used to avoid path explosion.

#definition(
  [*Path Explosion* describes the exponential growth of the number of paths in a CFG as the number of branching conditions increases.]
)

A program can be divided into smaller blocks of code or sequences of instructions that are divided by branching conditions. Each such block terminates either with a condition or the end of the entire program. By analysing where the program can jump to after each block, a control flow graph can be derived.

#definition(
  [And a *Control Flow Graph (CFG)* is a directed graph in which the nodes represent basic blocks and the edges represent control flow paths. @basicblock]
)

#definition(
  [A *Basic Block* is a linear sequence of program instructions having
one entry point (the first instruction executed) and one exit point
(the last instruction executed). It may of course have many predes-
sors and many successors and may even be its own successor. Program
entry blocks might not have predecessors that are in the program;
program terminating blocks never have successors in the program. @basicblock]
)



===  Constraint Solvers and Simulation Managers

The main strength of symbolic execution is that one can reason about how a specific state was reached by analysing the contraints put on the symbolic variables. In order to analyse the constraints, so called constraint solvers are usually part of a symbolic execution engine.

#definition(
  [*Constraint Solvers* evaluate a symbolic expression (constraints). A symbolic expression is _satisfiable_ if there exists an assignment for each symbolic variable so that the expression becomes true. A symbolic variable is _concrete_ if it is constrained to a single value.
  ]
)

During a symbolic execution, simulation mangers are used to decide which branch to analyse first when a branching condition is met. Depending on the analysis goal, specialised traversal or exploration techniques can be applied, often with a focus on mitigating path explosion.

#definition(
  [*Simulation Managers* determine the execution order of the basic blocks (nodes) in a CFG.]
)

Inherently, simulation managers provide a datastructure for state handling. Usually in form of different _stashes_ to sort the states in a useful way depending for the analysis goal.

Angr, a symbolic execution engine we will be looking at in @implementation in more detail, sorts its states using the stashes displayed in the figure below.

#pad(figure(
  supplement: [Figure],
  scale(diagram(
    node-stroke: 1pt,
    node((1,-1), [active]),
    edge("d","<|-|>"),
    node((1,0), [Simulation Manager]),
    edge("dl", "-|>"),
    edge("d", "-|>"),
    edge("dr", "-|>"),
    edge("drr", "-|>"),
    node((0,1), [deadended]),
    node((1,1), [pruned]),
    node((2,1), [unconstrained]),
    node((3,1), [error]),
    ),
  95%
  ),
  caption: "Default stash layout in angr"
),
10pt,
)

The simulation managers steps through the programs instruction, creating a state for each instruction found and moved into the active stash. On a branch condition, all possible paths are placed into the active stash. If a state has no next instruction, it goes into the deadended stash. states of unsatisfiable branches go into the pruned stash. When a instruction casues an error, its state goes into the error stash. Lastly, if the instruction pointer becomes unconstrained, the state goes into the unconstrained stash. Depending on the goal, a different behaviour and different stashes can be implemented.


=== Limitations of Symbolic Execution

Symbolic execution faces many limitations, such as scalability due to path explosion, loops leading to an infinite number of paths, and the difficulty of simulating parallel execution using a CFG. Other limitations include constraint solvers having difficulty solving floating-point numbers correctly, and many other issues described in more detail in @symEx_challenges.

== Other Analysis Techniques

*Fuzzing* is an alternative approach in which a program is executed with arbitrary concrete input while observing how far it will run before crashing. While this approach is much simpler than symbolic execution, it often fails to reach much depth and only covers a small percentage of the program code @fuzzorigin and @fuzzforeword

*Unit testing* is the most widely used technique, mostly relying on humans to identify all possible edge cases through manual testing. If users are involved in simulating user behaviour to find bugs, it is called *user testing*. In both cases, exhaustive coverage of all possible program paths is difficult to achieve.

== Static and Dynamic analysis
In *static analysis*, a program is analysed through its CFG, data flow, or other metrics that can be retrieved statically without executing the program. Symbolic execution is a form of static analysis, as it technically never executes the program, but rather simulates it @staticanalysis.

*Dynamic analysis*, on the other hand, involves executing (parts of) a program to collect runtime metrics. While challenging, achieving exhaustive path coverage can provide more meaningful results than static analysis @dynamicanalysis.

== Analysis Tools

#link("https://angr.io/")[*Angr*]#footnote("https://angr.io/") is one of the leading open-source Python frameworks for binary analysis. It is primarily developed by researchers at the #link("http://seclab.cs.ucsb.edu/")[Computer Security Lab at UC Santa Barbara]#footnote("http://seclab.cs.ucsb.edu/") and #link("http://sefcom.asu.edu/")[SEFCOM at Arizona State University]#footnote("http://sefcom.asu.edu/"), but has a dedicated open source community contributing to the project. It offers a variety of tools, ranging from CFG recovery over a powerful symbolic execution engine, to automatic exploit generation, and binary hardening.

It uses the #link("https://github.com/Z3Prover/z3")[*Z3 Theorem Prover*]#footnote("https://github.com/Z3Prover/z3") from Microsoft Research, together with #link("https://github.com/angr/claripy")[*Claripy*]#footnote("https://github.com/angr/claripy") also developed by Angr, as a constraint solver. Read more about Angr in @angr1 and @angr2.

#link("https://triton-library.github.io/")[*Triton*]#footnote("https://triton-library.github.io/") is an alternative binary analysis framework written in C++ and is published under the Apache 2.0 licence.
