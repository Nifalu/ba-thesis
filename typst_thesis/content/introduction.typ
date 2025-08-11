#import "@local/dmi-basilea-thesis:0.1.1": todo-missing

= Introduction <intro>

On October 29#super("th")  2018, Lion Air Flight 610, carrying 181 passengers and eight crew members, crashed into the Java Sea just minutes after taking off from Jakarta, Indonesia @lionair. Six months later, on March 10#super("th") 2019, Ethiopian Airlines Flight 302 crashed six minutes after taking off from Addis Ababa, Ethiopia, killing all 149 passengers and eight crew members @ethiopian. Both crashes were caused by a faulty sensor triggering a software component called MCAS (Maneuvering Characteristics Augmentation System), which repeatedly pushed the aircraft's nose downwards. The pilots struggled to overpower the computer until they ultimately lost control of the aircraft @undisclosedmcas.

MCAS @mcas itself is relatively simple. It reads the aircraft's current angle of attack and adjusts the trim in specific conditions. In isolation, each component worked as intended: the sensors measured the angle of attack, the flight control computer processed this data accordingly, and the trim system adjusted the aircraft's pitch. However, when integrated, a single sensor failure cascaded through the system, creating an unforeseen deadly scenario.

This tragedy exemplifies the fundamental challenges of modern safety-critical systems. While individual components may work flawlessly in isolation, their interactions can produce catastrophic behaviour. As digitalisation in aviation, automotive and industrial automation systems increases rapidly, they are becoming more complex and quickly exceeding the human ability to comprehend all possible failure modes.

Despite the increasing emphasis placed on 'security by design' principles, the reality in many organisations tells a different story. Engineering teams are often primarily composed of domain experts who possess deep technical knowledge but have limited experience in security principles. @safety-security-gap @securitybydesignreality

== Thesis Overview

This thesis presents an automated approach to analysing communication patterns in MCS through symbolic execution.

- *Chapter 2* provides the necessary background on multi-component systems and symbolic execution.

- *Chapter 3* presents our methodology, detailing how we retrieve component information, simulate message exchanges and construct communication graphs.

- In *Chapter 4* we have developed and implemented _MCS Analyser_, a tool that extracts actual message flows between components directly from their binaries, requiring minimal human input and no access to the source code.

- *Chapter 5* evaluates our approach through an expert interview with an aviation industry security specialist, discussing the tool's practical utility and current limitations.

The thesis continues with a discussion of technical constraints in *Chapter 6*,  a conclusion in *Chapter 7* and opportunities for future enhancement, particularly with regard to vulnerability detection and system state analysis in *Chapter 8*.

By automatically revealing the difference between actual and intended communication paths, this work aims to make hidden system interactions visible before deployment. This provides engineers with a practical tool to identify potentially dangerous component interactions that traditional review processes might miss.
