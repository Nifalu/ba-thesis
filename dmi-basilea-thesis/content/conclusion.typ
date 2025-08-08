#import "@preview/dmi-basilea-thesis:0.1.0": todo-missing

= Conclusion <conclusion>

This thesis presents an approach to analysing communication within multi-component systems used in aircraft, automotive vehicles and industrial automation. This approach involves symbolically executing the individual components to retrieve information about their input and output behaviour. This information is then used to create a graphical representation of the communication paths. We have developed a tool called *MCS Analyser* that implements this approach, and we have provided two example systems to demonstrate its capabilities.

An expert interview with Dr Mischa Jahn from Airbus highlighted the challenges of ensuring safety and security in systems developed by larger teams, in which only a few individuals possess security expertise. The interview showed that the ability to automatically determine communication paths can be incredibly useful for verifying that the system is behaving as intended. The expert also suggested improvements to *MCS Analyser* that would not only make it more effective at retrieving communication paths, but also at simulating the effects of these paths on the system itself. Another suggestion was to include a probability calculation to determine how likely it is that a certain path would be taken or exploited by an attacker.

The tool has limitations, such as path explosion and the need to align the analyser closely with the structure of the binaries. Nevertheless, it represents a step towards a more automated and reliable method of analysing multi-component systems. Given the expert's feedback and the list of potential improvements for future development, it is evident that the tool's potential remains significant.
