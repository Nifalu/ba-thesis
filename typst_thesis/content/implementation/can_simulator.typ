#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing, codly


=== The can_simulator Package <can_simulator>
This package contains the functionality required to simulate and model CAN bus communication. Unlike real Controller Area Networks, messages remain on the bus indefinitely. Read more about the effects of this in @technical-limitations #todo-missing("adjust this reference")


==== CANBus <canbus>

The `CANBus` is the core of the _can_simulator_ package and represents the simulated CAN bus.

During the initialisation, the config file is parsed and a _Component_ instance is created for each component defined in the config file. Then it tries to extract the names of the message ids from a single binary and stores them together with other metadata inside the `Config` singleton. Unlike described in @methodology, here the graph is created and adjusted as soon as the information is available.

#listing(caption: [Simplified view of phase 0, the `CANBus.init()` function], label: <im-canbus>)[
  #codly(highlights:(
    (line: 5, start: 5, end: 28),
    (line: 7, start: 5, end: 37),
    (line: 9, start: 17, end: 51),
    ))
    ```python
    def init(config_path):
      data = json.load(config_path)
      symbols = None
      for c in data['components']
        component = Component(c)
        cid = cls.components.add(component)
        MCSGraph.add_component(component)
        if not symbols:
          symbols = utils.extract_msg_id_map(component)
      Config.init(data, symbols)
    ```
]



The main function is the `write()` function, which is used to write messages to the bus. It takes a `produced_msg`, a new message to be written to the bus, and a list of `consumed_msgs`, the messages used to produce the new message, as parameters. It then performs a series of steps, updating various flags and lists, before eventually adding the produced message to the bus.

1. Throw a warning and return if the message type of the produced message is symbolic. Messages of any kind must always have a concrete type.

#listing(caption: none, label: <im-canbuswrite1>)[
    ```python
    def write(produced_msg, consumed_msgs):
      if produced_msg.type.is_symbolic:
        logger.warning(f"Message with symbolic type: {produced_msg}")
        return
    ```
]

2. Check if the produced message is already in the bus. Since each component is possibly analysed many times, it is very likely that the same output was produced before. The buffer is implemented as an `_IndexedSet_`, automatically assigning incremental IDs to each item added. The highlighted `buffer.add()` call simply returns the existing ID if the message is already in the bus. Otherwise the message will be added and the new ID is returned.

#listing(caption: none, label: <im-canbuswrite2>)[
  #codly(offset: 4, highlights:(
    (line: 7, start: 21, end: 48),
  ))
    ```python
      is_new_message = not cls.buffer.contains(produced_msg)
      produced_id = cls.buffer.add(produced_msg)

    ```
]

3. Create a new `production` object to store the origin of the produced message for later tracing. While the graph should be free of identical messages (edges) to improve readability, information about the message's origin is still of interest. The target is always the component that produced the current message. In other words, messages from other sources were consumed by the target to produce the new message.

#listing(caption: none, label: <im-canbuswrite3>)[
  #codly(offset: 6)
    ```python
        target = produced_msg.source
        consumed_ids = [cls.buffer.get_id(m) for m in consumed_msgs]
        MessageTracer.add_production(produced_id, consumed_ids, target)
    ```
]

4. If the message is new (#ie. not already in the bus), update the list that keeps track of how many messages of each type are currently in the bus. This list is used to determine whether a component can be analysed. 
5. Check if any previously analysed components can consume this message. If so, set the `is_analysed` flag to `False`.
6. Finally, update the graph by drawing edges from the sources of the consumed messages to the source of the produced message (#ie this component).

#listing(caption: [Overview of the `CANBus.write()` function (including the snippeds above).], label: <im-canbuswrite4>)[
  #codly(offset: 9)
    ```python
        if is_new_message: # 4.
          produced_msg_type = produced_msg.type.concrete_value
          cls.msg_types_in_buffer.update(produced_msg_type)
        
          for c in cls.components: # 5.
            if produced_msg_type in c.consumed_ids:
              c.is_analysed = False

        cls.update_graph(target, consumed_msgs) # 6.
    ```
]


The `update_graph()` function then appends an edge from each component that produced a consumed message to the target component that produced the new message to the _MCSGraph_. Only edges which are not already in the graph are added, to keep the graph clean and readable.
