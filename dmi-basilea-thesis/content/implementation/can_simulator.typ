#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm

=== The can_simulator Package <can_simulator>
This package contains the functionality required to simulate and model CAN bus communication. Unlike real Controller Area Networks, messages remain on the bus indefinitely. Read more about the effects of this in @technical-limitations

==== CANBus
#todo-missing("level 4 headings need to be smaller than levle 3 headings lol")

The *CANBus* is the core of the *can_simulator* package and represents the simulated CAN bus. During initialisation, it reads the configuration file and prepares the components, extracting the variable names for the message IDs to make them more readable later on.

The main function is the `write()` function, which is used to write messages to the bus. It takes a `produced_msg`, a new message to be written to the bus, and a list of `consumed_msgs`, the messages used to produce the new message, as parameters. It then performs a series of steps, updating various flags and lists, before eventually adding the produced message to the bus.

1. Throw a warning and return if the message type of the produced message is symbolic. Messages of any kind must always have a concrete type.
2. Check if the produced message is already on the bus, adding it if it is not. Since each component is analysed multiple times, there is a high chance of duplicate messages that can be safely discarded.
3. Create a new `production` object to store the origin of the produced message for later tracing. While the graph should be free of identical messages (edges) to improve readability, information about the message's origin is still of interest.
4. If the message is new (#ie. not already in the bus), update the list that keeps track of how many messages of each type are currently in the bus. This list is used to determine whether a component can be analysed. Also check if any previously analysed components can consume this message. If so, set the `is_analysed` flag to `False`.
5. Finally, update the graph by drawing edges from the sources of the consumed messages to the source of the produced message (#ie this component).

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
        message_data = {...} # metadata to be displayed in the graph
        MCSGraph.add_message_edge(source, target, message_data)

    ... # various helper methods

  ```,
  caption: [Simplified view of the `CANBus` class]
)
