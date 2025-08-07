#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes

= Evaluation <evaluation>

To evaluate the usefulness of MCS Analyser, we conducted an interview with an expert in the field. We selected this approach because user testing is difficult since the tool requires an in-depth understanding of symbolic execution and binary analysis, as well as a great deal of additional explanation. Benchmarks are also not suitable, as there is nothing to compare it with.

The expert in question is Mischa Jahn, who works in cybersecurity at Airbus Defence and Space, a subsidiary of Airbus. He has a background in applied mathematics, AI, and optimisation. He is currently working on the EU Horizon project Albatros, which has been running since 2022 with the goal of maintaining a high level of safety and resilience in aviation.

== Interview with Mischa Jahn

*What are the current challenges in terms of safety and security in aviation?*
One main difficulty is that everything in aviation has to meet strict certification standards, but these are also very unspecific for software, which leaves room for interpretation. Another challenge is that development is based on requirements, but it is rare to find people who understand the entire system. Most of the time, people or teams only understand a small section of the system, which makes it difficult to detect security issues caused by a dangerous combination of correct states.

*How do you deal with these challenges?*
The goal is to have security by design, meaning that security is integrated into the system's design right from the start, rather than being an afterthought. However, this is difficult to achieve in practice when most people working on the system mainly understand their own field and have limited knowledge of security and safety. Currently, we are trying to develop workflows and standards that will help ensure security by design, even if the people working on the system do not have a deep understanding of it.

*What are you currently working on?*
Another team of security experts is creating a threat model of the system manually. They determine how a component failure would propagate through the system. My role is to take this threat model and apply probabilities to the edges to determine how likely a failure is to propagate through the system. Ultimately, we conduct a 'what if' demonstration to showcase the consequences of a component failure.

*How would you rate the usefulness of the MCS Analyser, and what are its strengths and weaknesses?*
The ability to automatically obtain information on who talks to whom in a complex system is incredibly useful. When many people are working on a system, there is a high chance that someone will make a typo or misunderstand some part of the system and then push it, leaving the documentation outdated. Knowing how the system is actually communicating, compared to how it is intended to communicate, is also very useful.

An additional feature would be a percentage indicating how likely an unintended communication path could be exploited by an attacker. Also, a system can be safe even if it has issues, as long as these are identified and managed properly. Therefore, it would be useful to have a simulated goal state (e.g. an aircraft) that collects all the outcomes of communications, which can then be compared to ground truth. For example, we could define that an aircraft should never be in a certain state. Are there communication paths that could lead to such a state? If so, how likely is it that an attacker could exploit this?
