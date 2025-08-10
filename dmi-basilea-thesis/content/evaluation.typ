#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Evaluation <evaluation>

To evaluate the usefulness of the _MCS Analyser_, we interviewed an expert in the field. We selected this approach because user testing is difficult, given that the tool requires an in-depth understanding of symbolic execution and binary analysis, as well as considerable additional explanation. Benchmarks are also not suitable, as there is nothing with which to compare it.

The expert in question is Dr Mischa Jahn, who works in cybersecurity at Airbus Defence and Space, a subsidiary of Airbus. He has a background in applied mathematics, AI, and optimisation. He is currently working on the EU Horizon project Albatros, which has been running since 2022 with the goal of maintaining a high level of safety and resilience in aviation.

== Interview with Dr Mischa Jahn

*What are the current challenges in terms of safety and security in aviation?*

For me, the main challenge in terms of safety and security for a system, or a system of systems such as an aircraft, is the complexity and the extent of aspects to be considered. Many industries such as the aviation industry have to meet strict certification standards and specific guidelines have to be followed. In the past, the safety of systems was often considered independently of cybersecurity aspects. This can also be seen in the different standards, such as the DO-178C which addresses safety aspects of software but not security. However, with increased use of standardized commercial products and since components are more and more connected, modern systems can become more vulnerable to attacks from cyberspace. Therefore, cyber security considerations have to be integrated in the design and development processes. In regards to aviation, this led to the introduction of more certification standards, such as the DO-326A. Obviously, all of this increases the complexity so that, in the end, individual engineers tend to have only a deep understanding of specific parts of the system but not of the entire system. This results in adding new teams and makes having close cooperation across all divisions mandatory, all of which make the processes more extensive and, consequently, the development itself more expensive.

*How do you deal with these challenges?*

Since adding security measures to a finished design is not only more costly, but also not as effective as considering them during early design stages, the goal is to have security by design. This means that security aspects are integrated into the system's design right from the start, rather than being an afterthought. At Airbus we are developing, using, and continuously improving workflows, procedures, and tools that can be integrated in our day-to-day life and enable us to assess the impact of design decisions on security aspects and support engineers with different backgrounds and expertise in their work.

*What are you currently working on?*

Among other things, I am currently looking at the intersection of security and safety and more specifically at the impact of cybersecurity incidents and threats on the safety of systems such as aircrafts. For this, I am developing a flexible method to evaluate different designs and system configurations and compute the likelihood of pre-defined threat scenarios, impacting the safety of a system, to materialize under different conditions. The goal is to identify suboptimal designs as early as possible and support engineers in their work by providing rapid feedback on design decisions in terms of safety and security. For example, the tool can be used to determine how cyber-attacks, component failures or combinations of both would propagate through a system and how this would impact its safety state. In addition, the tool enables the quantification of possible root-causes and attack vectors and/or attack paths so that additional redundancies or security measures can be added if needed.

*How would you rate the usefulness of the _MCS Analyser_, and what are its strengths and weaknesses?*

The ability to automatically obtain information and a visualization of which systems communicate to each other and analyze the data flow in a complex system is incredibly useful. I can imagine scenarios where many people are working on the design of a system or related controller software, either during the initial development or at a later stage as a new version, where either the documentation is outdated and therefore misses some communication paths or where mistakes happen and such paths are created through an oversight. Knowing how the system is actually communicating by considering all possible paths and comparing this to how it is intended to communicate, can be extremely useful.

An additional feature that would be very interesting could be to include a probability indicating how likely an unintended communication path could be exploited by an attacker and how this impacts the final state of a system. A system could be considered as “safe” even if there are security issues, as long as these are identified and managed properly. Therefore, it would be useful to have a simulated goal state (e.g. the safety of a system or the system of systems such as an aircraft) that considers all the outcomes of all paths and compare them to defined values or thresholds leading to specific conditions and states. For example, we could define that a system should never be in a certain state. Are there communication paths that could lead to such a state? If so, how likely is it that an attacker could exploit this?

#todo-missing("insert references for the certification standards mentioned above")
