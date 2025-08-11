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

#include("requirements.typ")
#include("structure.typ")

== How it works

#include("coordinator.typ")
#include("can_simulator.typ")
#include("component_analyser.typ")
#include("io_package.typ")
#include("common_package.typ")
