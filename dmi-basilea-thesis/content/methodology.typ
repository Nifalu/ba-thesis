#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Methodology <methodology>

#todo-missing("Update the Algorithm look. Add a optional title, input-output, line numbers etc. ")

There are three main types analysis techniques:
- *White box testing* where the analyst has full knowledge about the thing he is analysing.
- *Black box testing* where the analyst only observes the behaviour without any knowledge about the internals of the thing he is analysing.
- *Gray box testing* is somewhere in between white box and black box testing.

In a MCS (@mcs), each component individually might work as intended but together they can still produce dangerous outcomes. And as the number of possible states a MCS system increases exponentially with every added component, grasping all of them becomes rather impossible for humans. We decided to target an approach where we retrieve as much information as possible out of the programs themselves and reduce additional human input where possible.

We analyse a MCS in three phases. In phase one we retrieve information about the systems structure that we later need in phase two for the simulation. In a last phase we stich together our results to build a graph representation of all possible communication paths found during the simulation.

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

Since we are ultimatively simulating a CAN bus, we are interested in what a component _consumes_ as input, either from the bus or from external sources (#eg sensor measurements) and what a component _produces_ as output. Again either writing to the bus or producing external output (#eg controlling electronics)

In order to evaluate input and output in a meaningful way we have to define a minimalistic protocol used on the bus:

#definition(title: "Definition 1",[A *Message* always consists of a *Message id*  describing the *type* of the message and the *Message data* holding the actual content of the message.\ For our visualisation we also store the producer of the message as metadata.])

== Information Retrieval <phase1>
The goal of this phase is to all the information needed for the simulation. This is done by symbolically executing each component with unconstrained (arbitrary) input data. Due to the nature of symbolic execution, this will yield all possible execution paths and therefore also all possible inputs and outputs a component can consume and produce.

By evaluating the constraints on the symbolic variables that were consumed as input and also on those produced as output, we can retrieve information about which input the component will accept and what it will produce given that input.

#algorithm(
  ```
  fun retrieve_info(c):
    produced_messages = set()
    for c in components:
      entry_point = find_entry_point(c)
      output_addrs = find_output_addrs(c)
      output_states = explore(c, find=output_addrs) # Symbolic exploration
      for state in output_states:
        in_data, out_data = retrieve_io_data()
        c.consumes.add(in_data.types) # Store what types it consumes
        c.produces.add(out_data.types) # Store what types it produces
        produced_messages.append(Message(in_data, out_data))
    return produced_messages
  ```
  , caption: "Information Retrieval")

== Simulation <phase2>
Knowing what each component consumes and produces, we can build an initial simulation order. Those which consume only a single input cannot read a message id _and_ data can therefore be labeled as *leaf component*, components that are not expected to read from the bus. We mark those components as "analysed".

In a *first step* we put all produced outputs from the previous step into a buffer. We could say, those outputs are now _messages in the bus_.

In a *second step* we are looking for a component that consumes only types of messages that are already in the buffer. If a component is found, we calculate all possible combinations of inputs out of all the inputs whose type is supported by the component. Then this component is analysed for each combination and mark the component as "analysed". The produced outputs are placed in the buffer.

For each produced message we have to check if any previously analysed component could potentially consume this message and if so, we mark that component as "not analysed". Repeat from second step until all components are "analysed".

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


== Graph Visualisation <phase3>
During the previous step, all produced messages were placed in the buffer. It holds all the necessary information to build a graph.

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
