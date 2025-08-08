= Future Work <future-work>

*MCS Analyser* is a first step towards a more automated and reliable way of analysing multi-component systems. It is useful for displaying the actual communication paths between components, as opposed to the paths that a team of developers might expect. However, there is scope to improve and extend the features of the *MCS Analyser*.

== Technical Improvements
Currently, *MCS Analyser* has some technical limitations in terms of how it analyses binaries and retrieves information. These limitations include:

- *Path explosion:* currently, *MCS Analyser* initially symbolically executes the entire binary to retrieve a `CFGEmulated`, which is then used in subsequent analysis runs to avoid paths that do not lead to an output function. While this approach dramatically improves performance, the initial symbolic execution is still expensive and prone to path explosion. A significant improvement would be to find a way to avoid full symbolic execution of the binary while still benefiting from avoiding paths in later analysis runs, especially for larger binaries.

- *Non-linear control flow*, such as loops or recursion, can lead to potentially infinite paths, which further promotes path explosions. In MCS systems, components usually continuously read sensor measurements or messages from the bus. Therefore, it is likely that the input functions are in some form of continuous, infinite loop. There might also be components that calculate an aggregated value over time; these would potentially require multiple iterations of the loop in order to function correctly, while others could be simulated with a single input. Angr does have some mechanisms to detect loops, but these are not currently used in *MCS Analyser* and would need to be investigated.

- *When is a component ready to be analysed?* Currently, *MCS Analyser* retrieves the maximum number of inputs that a component will ever read, and then determines whether this number can be provided by the messages on the bus. This is a rather simplistic approach, as the component may already function with fewer inputs. Further investigation into how this could be determined would improve the robustness of the analysis and cover more edge cases.

== Feature Extensions
As mentioned in the evaluation and discussion, *MCS Analyser* could be extended with additional features to make it more useful in real-world scenarios. Potential extensions are not limited to:

- *Path probability calculation:* Currently, *MCS Analyser* simply displays all communication paths found during the simulation. It would be interesting to calculate the probability of a certain path being taken.

- *Bug and Vulnerability Detection:* It would be useful to have an indication of how prone a certain component is to bugs or vulnerabilities. By extending the analysis steps, it would be possible to check for common patterns that lead to bugs or vulnerabilities. This could also be combined with path probability calculation to determine the likelihood of a component or path being exploited by an attacker.

- *Effects on the system:* Usually, components not only read and write messages to the bus, but also control some electronics or hydraulics, which change the state of the system itself. From an outside perspective, it does not matter if there are bugs or errors within the system, as long as they are identified and addressed properly, ensuring that the system itself does not end up in an unsafe state. Therefore, it would be interesting not only to simulate communication paths, but also their effects on the system itself. Ultimately, it would be interesting to define a set of states that the system should never be in, and then use a "what if" approach to check how likely it is to reach such a state. This could be achieved by adding a new binary to the list of components that reads the relevant messages and simulates system behaviour. The *MCS Analyser*, in its current form, would automatically analyse this binary and display the resulting constraints, which could then be compared to some ground truth.
