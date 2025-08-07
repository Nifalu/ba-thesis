= Future Work <future-work>

*MCS Analyser* is a first step towards a more automated and reliable way to analyse multi-component systems and proves to be useful in displaying the actual communication paths between components compared to the expected paths a team of developers might have in mind. However there is a lot of work that can be done to improve or extend the features of *MCS Analyser*.

== Technical Improvements
Currently *MCS Analyser* has some technical limitations in terms of how it analyses the binaries and how it retrieves information. These limitations are not limited to:

- *Path Explosion:* Currently *MCS Analyser* initially symbolically executes the entire binary to retrieve a `CFGEmulated` which is then used in following analysis runs to avoid paths that do not lead to an output function. This approach already improves the performance dramatically but that initial symbolic execution is still expensive and prone to path explosion. Finding a way to not require a full symbolic execution of the binary but still having the benefits of avoiding paths in later analysis runs would be a significant improvement especially for larger binaries.

- *Non-linear Control Flow* such as loops or recursion lead to potentially infinite paths with further promotes path explosions. In MCS Systems, components usually continously read some sensor measurement or messages from the bus. Therefore it is likely that the input functions are in some form of a continous, infinite loop. Also there might be components that calculate some aggregated value over time, those would potentially require multiple loop iterations in order to function correctly while others can just be simulated with a single input. *Angr* does have some mechanisms to detect loops but they are currently not used in *MCS Analyser* and would need to be looked into.

- *When is a component ready to be analysed?* Currently *MCS Analyser* retrieves the maximum number of inputs a component will ever read and then determine if this number can be provided by the messages in the bus. This is a rather simplistic approach as the component might already work with less inputs. Further investigating how this could be determined would improve the robustness of the analysis and covering more edge cases.

== Feature Extensions
As mentioned in the evaluation and discussion, *MCS Analyser* could be extended with additonal features to make it more useful in real world scenarios. Potential extensions are not limited to:

- *Path Probability Calculation:* Currently *MCS Analyser* simply displays all communication paths found during the simulation. It would be interesting to calculate the probability of a certain path being taken.

- *Bug and Vulnerability Detection:* It could be interesting to have some indication of how prone a certain component is to bugs or vulnerabilities. By extending the analysis steps, one could check for common patterns that lead to bugs or vulnerabilities. This could also be combined with the path probability calculation to determine how likely it is that a certain component or path is exploited by an attacker.

- *Effects on the System:* Usually components are not only reading and writing messages to the bus but also controlling some electronics or hydraulics which change the state of the system itself. From an outside perspective it does not matter if there are bugs or errors within the system as long as they are caught and handled properly so that the sytem itself does not end up in an unsafe state. Therefore it would be interesting to not only simulate the communication paths but also the effects of those paths on the system itself. In the end it could be interesting to define a set of states in which the system should never be in then check in a "what if" manner if and how likely it is to reach such a state. This could be achieved by adding a new binary to the list of components that reads the relevant messages and simulates the system behaviour. *MCS Analyser* in its current form would automatically analyse this binary and display the resulting constraints which can then be compared to some ground truth.


