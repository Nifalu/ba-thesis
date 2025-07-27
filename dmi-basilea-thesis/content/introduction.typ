#import "@preview/dmi-basilea-thesis:0.1.0": todo-missing

= Introduction <intro>

Software Security in multicomponent systems...
Each component 'might' work on its own but combined they might produce states in which parts of the system fail

Classic examples are aircrafts, (semi)-autonomous cars, trains or ships, but also industrial machines where a lot of small components and sensors communicate with each other to reach a greater goal.

Methods to ensure correct behaviour, correctness but also the secureness of a software
- User testing (user)
- Unit testing (programmer)
- Fuzzing (blackbox, whitebox, greybox)
- Symbolic Execution (simulation)

== Challenges with multi component systems

- Number of ways the system can fail increases with every component.
- Difficult for humans to grasp every possibility of failure. Many edge cases
#todo-missing("Ask airbus guy about their difficulties")

== Thesis Overview

- Present an approach on how we can simulate a multi component system with the help of symbolic execution to trace communications between the components, get a better understanding on how the system can perform (compared to the expected behaviour) and possibly find discrepancies and bugs that may indicate a security related issues.

#todo-missing("Do we add schnauzer visualisation?")

The next chapter provides the essential background to fully understand the concepts and techniques used in the later chapters.

Chapter 3 explains the theoretical approach to analysing multi-component systems followed by chapter 4 with a detailed overview on the practical implementation of #todo-missing("Insert the name of the Analyser")
#todo-missing("Finish overview")
