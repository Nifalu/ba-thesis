#import "@preview/dmi-basilea-thesis:0.1.1": todo-missing, definition, eg, ie, algorithm
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge, shapes
= Implementation <implementation>

This chapter focuses on the practical implementation of the previously introduced approach to analyse a Multi Component System. We developed a tool called *MCS Analyser* #todo-missing("Insert Github link") which uses the binary analysis platform #link("https://angr.io/")[*angr*] for the analysis part as well as a self-written visualisation library #link("https://github.com/Nifalu/schnauzer")[*Schnauzer*]#footnote("https://github.com/Nifalu/schnauzer") to display the resulting graph in a interactive way. *MCS Analyser* is public, open-source and with expandablity in mind. Information for developers who want to contribute can be found in the `README`.

#todo-missing("Write and link README")

#include("usage.typ")
#include("requirements.typ")
#include("structure.typ")

== How it works

#include("coordinator.typ")
#include("can_simulator.typ")
#include("component_analyser.typ")
#include("io_package.typ")
#include("common_package.typ")
