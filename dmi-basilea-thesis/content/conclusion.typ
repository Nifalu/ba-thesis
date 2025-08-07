#import "@preview/dmi-basilea-thesis:0.1.0": todo-missing

= Conclusion <conclusion>

This thesis presented an approach to analyse the communication within multi-component systems used in aircrafts, automotives and industry automation. The approach is based on symbolically executing the individual components to retrieve information about their input and output behaviour. This information is then used to build a graph representation of the communication paths. We developed a tool called *MCS Analyser* that implements this approach and provide two example systems to demonstrate its capabilities.

An expert interview with Mischa Jahn from Airbus highlighted the challenges of ensuring safety and security in systems developed by larger teams where only a few people have the expertise in security. It showed that the ability to automatically determine communication paths in a black box manner can be incredibly useful to verify that the system is behaving as intended. The expert also suggested improvements to *MCS Analyser* that would make it more useful in not only retrieving communication paths, but also simulating the effects of these paths on the system itself. Or to include a probability calculation to determine how likely it is that a certain path is taken or exploited by an attacker.

The tool is not without limitations, such as path explosion and the need to align the analyser closely with the structure of the binaries. However, it is a step towards a more automated and reliable way to analyse multi-component systems and given the feedback from the expert and the list of possible improvements for future work, it is clear that there is still a lot of potential for further development.
