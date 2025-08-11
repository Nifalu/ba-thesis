#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, listing, codly
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Methodology <methodology>

In a MCS, each component can work as intended and produce valid outputs, but a dangerous combination of valid states may result in system failure. As the number of possible states in an MCS system increases exponentially with every added component, it becomes impossible for humans to grasp them all. This chapter presents an approach on how a MCS can be better understood by analysing the communication paths withn the MCS and visualising it in a human readable way.

Before conducting a (security) analysis on a system, one has to decide between three main analysing types:

- A *White Box Testing* is an analysis technique where the internal structure and workings of a system are known to the analyst and are usually also the focus of the analysis.
- In contrast, *Black box testing* is an analysis technique where the internal structure is completely hidden from the analyst and only the behaviour or functionality is analysed.
- Lastly, *Gray box testing* is a mix between the two where some details about the internal structure is known in order to make black box testing more efficient.

Since we assume that individual humans cannot grasp the complexity of the system, we cannot assume to have correct knowledge of the internal workings. We therefore aimed towards a black box approach, requirering as little information as possible about the system before conducting the analysis.

Our approach can be divided into three phases:
- In *Phase I*, information is retrieved about the system's structure.
- In *Phase II*, the system's components are symbolically executed and their input/output behaviour analysed.
- In *Phase III*, the results are stitched together to create a graphical representation of all the possible communication paths identified during the simulation.

#figure(
  supplement: [Figure],
  pad(scale(diagram(
    node-stroke: 1pt,
    edge((-1,0), "r", "-|>", label: "MCS", label-pos: 0.2),
    node((0,0), [Information Retrieval]),
    edge("r", "-|>"),
    node((1,0), [Simulation]),
    edge("r", "-|>"),
    node((2,0), [Visualisiation]),
    edge("r", "-|>", label: "Graph", label-pos: 0.8)
    ),
  95%
  ),
  10pt,
  ),
  caption: "Phases of the MCS Analysis"
)

In order to to analyse the communications, the analyser must understand the communication protocol. In this case, the CAN protocol, which inherently defines how messages are structured. In this thesis, we will use a protocol that defines the message structure as follows:

#definition(
  [A *Message* always consists of a message ID describing the type of the message and message data holding the actual content of the message.]
)

== Information Retrieval <phase1>
The goal of this phase is to collect all the information needed for the simulation. This is achieved by symbolically executing each component with unconstrained (arbitrary) input data. Due to the nature of symbolic execution, all possible execution paths are yielded, as well as all possible inputs and outputs that a component potentially consumes and produces.

By evaluating the constraints on the symbolic variables consumed as input and produced as output, information can be retrieved about which inputs the component will accept and what it will produce given those inputs.

== Simulation <phase2>
During the simulation phase, the interesting metrics are what a component *consumes* as input (either from the bus or from external sources, e.g. sensor measurements) and what a component *produces* as output. Again, this involves either writing to the bus or producing external output (e.g. controlling electronics).

First, all outputs produced in the information retrieval phase are placed in a buffer. This buffer contains all the messages ever produced by any component.

#listing(caption: [Retrieving information by symbolically executing all components with unconstrained inputs], label: <lst:th-info-ret>)[
  #codly(highlights:(
    (line: 4, start: 52, end: 69),
    ))
    ```python
    buffer = []
    def run_with_unconstrained_input()
      for c in components:
        produced_messages = do_symbolic_execution(c, unconstrained=True)
        buffer.append(produced_messages)
    ```
]

Once it is known what each component consumes and produces, an initial simulation order can be determined. Components that consume only a single input cannot read both a message ID and data, and are therefore not expected to read from the bus. These components are marked as 'analysed'.

#listing(caption: [Marking single-input components as analysed], label: <lst:th-mark-leafs>)[
  #codly(
    offset: 5,
    )
    ```python
    for c in components:
      if len(c.consumes) == 1:
        c.analysed = True
    ```
]

Secondly, a component that consumes only the types of messages already in the buffer is searched for.

#listing(caption: [Check of enough messages are available for an analysis], label: <lst:th-can_analyse>)[
  #codly(
    offset: 8
  )
    ```python
    def can_analyse(c):
      supp_types = c.supported_msg_types
      return c.max_expected_inputs <= buffer.contains_num_of(supp_types)
    ```
]

If one is found, all possible combinations of inputs are calculated from all inputs whose type is supported by the component. The component is then analysed for each combination and marked as _analysed_. The produced outputs are placed in the buffer.

Next, check if any previously analysed component could potentially consume each produced message. If so, mark that component as _not analysed_. Repeat the second step until all components are _analysed_.

#listing(caption: [Loop through the components until all are analysed], label: <lst:th-analysing-loop>)[
  #codly(
    offset: 11,
    highlights:(
    (line: 17, start: 10, end: 23),
    (line: 22, start: 7, end: 37),
    ))
    ```python
    while True:
      progress = False
      for c in components:
        if c.is_analysed:
          continue
        elif can_analyse(c):
          inputs = generate_input_combination(c, buffer)
          for input in inputs:
            produced_messages = do_symbolic_execution(c, input)
            buffer.add(produced_messages)
          check_reopen(produced_messages)
          progress = True
      if not progress:
        break
    ```
]

The actual binary analysis takes place inside `do_symbolic_execution()` which performs a sequence of steps:
1. Build a CFG for the binary.
2. Statically find the addresses of input and output functions within the binary.
3. Symbolically execute towards the input addresses using a CFG to avoid other paths to retrieve the state of the program right before the input functions. We call those states (entry states)
4. Hook the input function to provide our own input.
5. Symbolically execute towards the output addresses starting from the states retrieved in step 3.
6. Evaluate the symbolic expressions on the state right before the output function is called to retrieve what symbolic value is passed to that output function.

Function hooking (step 4) is a common feature in binary analysis. It allows the analyser to inject or replace code at specific points in the binary. We use hooks to replace the input functions with our own version, allowing us to inject our own symbolic variables as input which simplifies tracking them later on.

#definition(
  [*Hooks* allow the interception and redirection of function calls or code execution to custom implementations. This enables injecting modified behavior or monitoring program execution without altering the original binary.]
)


== Graph Visualisation <phase3>
The buffer now contains all the messages produced during the simulation phase, each one appended with metadata about the component that produced it. From the first phase it is known which components can consume which message types, so all the information needed to build a graph is available.

#listing(caption: [Infer the graph from the messages in the buffer], label: <lst:th-analysing-loop>)[
  #codly(
    offset: 25,
    )
    ```python
    G = MultiDiGraph
    for c in components:
      G.add_node(c)
    for msg in buffer:
      if msg_id in c.consumes:
        G.add_edge(msg_source, c, msg)
    ```
]
