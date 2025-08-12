#import "@local/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, listing
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
= Implementation <implementation>

This chapter focuses on the practical implementation of the approach to analysing a Multi Component System that was introduced previously. We have developed a tool called #link("https://github.com/Nifalu/mcs-analyser")[_*mcs-analyser*_]#footnote("https://github.com/Nifalu/mcs-analyser"), which uses the binary analysis platform #link("https://angr.io/")[*angr*] for the analysis part, as well as a self-written visualisation library #link("https://github.com/Nifalu/schnauzer")[*schnauzer*]#footnote("https://github.com/Nifalu/schnauzer") to display the resulting graph interactively. _MCS Analyser_ is public and open-source, and has been designed with expandablity in mind.

==== Links
Tool developed in this thesis:
- *mcs-analyser:* #link("https://github.com/Nifalu/mcs-analyser")
Dependencies:
- *angr:* #link("https://github.com/angr/angr") (binary analysis)
- *schnauzer:* #link("https://github.com/Nifalu/schnauzer") (visualisation)

==== Try it out yourself (macOS / Linux):
Installation:
1. `git clone git@github.com:Nifalu/mcs-analyser.git`
2. `cd mcs-analyser`
3. `python -m venv .venv`
4. `source .venv/bin/activate`
5. `pip install -r requirements.txt`

Run in two separate terminals (both inside .venv environment):
- Visualisation Server: `schnauzer-server`
- MCS Analyser: `python main.py --config config_cesna.json`

Open #link("localhost:8080")[`localhost:8080`] in a browser to see the result

==== General Requirements with MCS Analyser
For the _MCS Analyser_ to work correctly, it must be aligned with the architecture and the structure of the binaries to be analysed. The _MCS Analyser_ is based on the assumption that components communicate according to a well-defined protocol that matches the one introduced in @methodology .

To increase the readability and interpretability of the resulting graph, optionally:
- Compile the binaries with debug information to allow the _MCS Analyser_ to retrieve the names of the message types (#eg Engine RPM instead of `0x1234`).
- Disable compiler optimisations to ensure that the analysed binary is as close to the source code as possible.

Angr does technically support various architectures, _MCS Analyser_ currently only works with x86-64 (AMD64) binaries. Use the following command to simply compile to x86-64 without having to deal with cross compilers, especially on ARM based machines.

```bash
docker run --platform linux/amd64 --rm -v "$(pwd):/work" -w /work gcc:latest gcc -g -O0 "$input_file" -o "$output_file"
```

#include("structure.typ")

== How it works

#include("coordinator.typ")
#include("can_simulator.typ")
#include("component_analyser.typ")
#include("io_package.typ")
#include("common_package.typ")
