#import "@preview/dmi-basilea-thesis:0.1.0": todo-missing

= Introduction <intro>

On 29 October 2018, Lion Air Flight 610, which was carrying 181 passengers and eight crew members, crashed into the Java Sea just minutes after taking off from Jakarta, Indonesia. Six months later, on 10 March 2019, Ethiopian Airlines Flight 302 crashed six minutes after taking off from Addis Ababa, Ethiopia, killing all 149 passengers and eight crew members. Both crashes were caused by a faulty sensor triggering a software component called MCAS, which repeatedly pushed the aircraft's nose downwards. The pilots struggled to overpower the computer until they ultimately lost control of the aircraft.

MCAS itself is relatively simple: it reads the aircraft's current angle of attack and adjusts the trim in specific conditions. In isolation, each component worked as intended: the sensors measured the angle of attack, the flight control computer processed this data accordingly, and the trim system adjusted the aircraft's pitch. However, when integrated, a single sensor failure cascaded through the system, creating an unforeseen deadly scenario.

This tragedy exemplifies the fundamental challenges of modern safety-critical systems. While individual components may work flawlessly in isolation, their interactions can produce catastrophic behaviour. As digitalisation in aviation, automotive and industrial automation systems increases rapidly, they are becoming more complex and quickly exceeding the human ability to comprehend all possible failure modes.

Despite the increasing emphasis placed on 'security by design' principles, the reality in many organisations tells a different story. Engineering teams are often primarily composed of domain experts who possess deep technical knowledge but have limited experience in security principles.

#todo-missing("Insert sources / references")

== Thesis Overview

This thesis presents an automated approach to analysing communication patterns in multi-component systems through symbolic execution. We have developed and implemented MCS Analyser, a tool that extracts actual message flows between components directly from their binaries, requiring minimal human input and no access to the source code.

*Chapter 2* provides the necessary background on multi-component systems and symbolic execution.

*Chapter 3* presents our methodology, detailing how we retrieve component information, simulate message exchanges and construct communication graphs.

*Chapter 4* describes the practical implementation of MCS Analyser, including its architecture and two demonstration systems from the automotive and aviation industries.

*Chapter 5* evaluates our approach through an expert interview with an aviation industry security specialist, discussing the tool's practical utility and current limitations.

The thesis concludes with a discussion of technical constraints and opportunities for future enhancement, particularly with regard to vulnerability detection and system state analysis.

By automatically revealing the difference between actual and intended communication paths, this work aims to make hidden system interactions visible before deployment. This provides engineers with a practical tool to identify potentially dangerous component interactions that traditional review processes might miss.
