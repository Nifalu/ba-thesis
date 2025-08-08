#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

=== can_simulator Package <can_simulator>
The `can_simulator` package contains functionality to simulate and model CAN bus communication. It differs from real Controller Area Networks in that messages remain in the bus indefinitely. Read more about the effects of this in @technical-limitations

==== CANBus
#todo-missing("level 4 headings need to be smaller than levle 3 headings lol")
The `CANBus` core of the `can_simulator` package and represents the simulated CAN bus. During initialisation it reads the configuration file, prepares the components extracts the variable names for the message ids in order to display more readable names later.

Its main function is the `write()` function which is used to write messages to the bus. It takes the `produced_msg`, the new message that should be written to the bus, and a list of `consumed_msgs`, the messages that were used to produce the new message, as parameters. It then performs a series of steps, updating various flags and lists and eventually adds the message to the bus.

1. Throw a warning and return if the message type of the produced message is symbolic. Messages of any kind must always have a concrete type.
2. Check if the produced message is already in the bus and add it if not the case. Since each component is analysed multiple times, there is a high chance of duplicate messages which we dont need to add again.
3. Create a new `production` object to store the origins of the produced message, needed for message tracing later. Even though we do not want to display the same message twice in the graph, this same message might be produced by different inputs. Therefore we still need to ttrack where the message originated from.
4. If it is a new message, (#ie not already in the bus), we update a list keeping track of how many messages of each type are currently in the bus. This is used to determine if a component can be analysed or not. We also need to check if any previously analysed component can consume this message and if so, set its `is_analysed` flag to `False`.
5. Finally we update the graph, drawing edges from the sources of the consumed messages to the source of the produced message, #ie this component.

#algorithm(
  ```python
  class CANBus:
    components: IndexedSet[Component] = IndexedSet()
    msg_buffer: IndexedSet[Message] = IndexedSet()
    msg_types_in_buffer: dict[int, int] = dict()

    def init(config_path):
      config = read(config_path)
      self.components = config["components"] #simplified

    def write(produced_msg: Message, consumed_msgs: set[Message]):
      target = produced_msg.producer

      if produced_msg.type.is_symbolic():
        return

      produced_msg_type = produced_msg.type.concrete_value
      is_new_msg = not msg_buffer.contains(produced_msg)
      produced_msg_id = msg_buffer.add(produced_msg) # returns an id
      consumed_msgs_ids = msg_buffer.get_ids(consumed_msgs)

      MessageTracer.add_production(produced_msg_id, consumed_msgs_ids)

      if is_new_msg:
        msg_types_in_buffer[produced_msg_type] += 1

        for c in components:
          if c.can_consume(produced_msg_type:
            c.is_analysed = False

      update_graph(target, consumed_msgs)

    def update_graph(target, consumed_msgs):
      for msg in consumed_msgs:
        consumed_msg_id = buffer.get_id(msg)
        message_data = {...} # data to be displayed in the graph
        MCSGraph.add_message_edge(source, target, message_data)

    ... #various helper methods

  ```,
  caption: [Simplified view of the `CANBus` class]
)
