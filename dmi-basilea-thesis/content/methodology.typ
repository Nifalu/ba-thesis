#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Methodology <methodology>

There are three main types of analysis techniques:
- *White box testing*, where the analyst has full knowledge of the thing being analysed.
- *Black box testing*, where the analyst only observes the behaviour without knowing anything about the internals of the thing being analysed.
- *Gray box testing*, which is somewhere in between white box and black box testing.

In a Multi-Component System, each component can work as intended and produce valid outputs, but a dangerous combination of valid states may result in system failure. As the number of possible states in an MCS system increases exponentially with every added component, it becomes impossible for humans to grasp them all. The approach presented in this chapter retrieves as much information as possible from the programs themselves, reducing the need for additional human input.

The analysis of such a system can be divided into three phases. In phase one, information is retrieved about the system's structure. In phase two, the system's components are symbolically executed and their input/output behaviour analysed. In the final phase, the results are stitched together to create a graphical representation of all the possible communication paths identified during the simulation.

#figure(
  supplement: [Figure],
  pad(scale(diagram(
    node-stroke: 1pt,
    edge((-1,0), "r", "->", label: "MCS", label-pos: 0.2),
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

During the simulation phase, the interesting metrics are what a component *consumes* as input (either from the bus or from external sources, e.g. sensor measurements) and what a component *produces* as output. Again, this involves either writing to the bus or producing external output (e.g. controlling electronics).

To evaluate input and output meaningfully, the analyser must understand the bus protocol. The protocol inherently defines how messages are structured. In this thesis, we will use a much simplified protocol that defines the message structure as follows:

A *Message* always consists of a message ID describing the type of the message and message data holding the actual content of the message.

== Information Retrieval <phase1>
The goal of this phase is to collect all the information needed for the simulation. This is achieved by symbolically executing each component with unconstrained (arbitrary) input data. Due to the nature of symbolic execution, all possible execution paths are yielded, as well as all possible inputs and outputs that a component potentially consumes and produces.

By evaluating the constraints on the symbolic variables consumed as input and produced as output, information can be retrieved about which inputs the component will accept and what it will produce given those inputs.

== Simulation <phase2>
Once it is known what each component consumes and produces, an initial simulation order can be determined. Components that consume only a single input cannot read both a message ID and data, and are therefore not expected to read from the bus. These components are marked as 'analysed'.

First, all outputs produced in the information retrieval phase are placed in a buffer. This buffer contains all the messages ever produced by any component.

Secondly, a component that consumes only the types of messages already in the buffer is searched for. If one is found, all possible combinations of inputs are calculated from all inputs whose type is supported by the component. The component is then analysed for each combination and marked as 'analysed'. The produced outputs are placed in the buffer.

Next, check if any previously analysed component could potentially consume each produced message. If so, mark that component as 'not analysed'. Repeat the second step until all components are 'analysed'.

== Graph Visualisation <phase3>
The buffer now contains all the messages produced during the simulation phase, each one appended with metadata about the component that produced it. It is also known which components can consume which message types, so all the information needed to build a graph is available.

#algorithm(
  ```
  buffer = retrieve_info() // phase 1
  for c in components:
    if len(c.consumes) == 1:
    c.analysed = True

  while True:
    progress = False
    for c in components:
      if c.is_analysed:
        continue
      elif can_analyse(c): # Check if inputs for this component are available
        # Find all combinations of inputs available for this component
        inputs = generate_input_combination(c, buffer)
        for input in inputs:
          io_data = analyse(c, input)
          buffer.add(io_data)
        check_reopen(io_data) # Check if we need to reanalyse a component
        progress = True
    if not progress:
      break

  fun analyse(c, input):
    entry_point = find_entry_point(c)
    output_addrs = find_output_addrs(c)
    output_states = explore(c, find=output_addrs) # Symbolic exploration

    io_data = []
    for state in output_states:
      in_data, out_data = retrieve_io_data()
      io_data.append((in_data, out_data))
    return io_data
  ```
  , caption: "Simulation Phase")



#algorithm(
  ```
  G = MultiDiGraph
  for c in components:
    G.add_node(c)

    for msg in buffer:
      if msg_id in c.consumes:
        G.add_edge(msg_source, c, msg)
  ```
  , caption: "Build the Graph")

#todo-missing("Those two algorithms feels misplaced or it needs more detailed explanation")
