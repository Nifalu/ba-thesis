---
geometry:
  - left=1.3in
  - right=1.3in
  - top=1.5in
  - bottom=1.5in
page-numbers: false
pagestyle: empty
---

# Project Description

## Drawing Attack Graphs for Multi-Component Systems

### Short Description

In complex systems, especially in safety-critical domains such as aviation, self-driving cars, trains or ships, it is necessary to understand how component failures can propagate through the system. This work aims to develop a formal approach to analyze and model the propagation of failures in multi-component systems using attack graphs. These graphs will be useful to identify critical components and paths within the system and to develop strategies to mitigate the effects of failures.

### Long Description

**English:**

In complex systems, especially in safety-critical domains such as aviation, self-driving cars, trains or ships, it is necessary to understand how component failures can propagate through the system. Often these systems are too complex to analyze manually, and even when critical components are identified, it is difficult to grasp the full impact of a failure.

This work aims to create a formal representation of multi-component systems through "attack graphs" that visualize the propagation of failures. Using "symbolic execution", the input/output behavior of each component is analyzed and based on their interactions, a graph can be generated.

The goal is to provide a tool that allows the user to give it different components, define their interactions, and specify illegal states or outputs. The tool will then perform symbolic execution on each component according to the data flow between them, analyze whether inputs lead to illegal outputs, and generate an attack graph. This can then be used by system engineers to identify critical components and paths within the system, and to develop strategies to mitigate the impact of failures.


**German:**

Bei komplexen Systemen, insbesondere in sicherheitskritischen Bereichen wie der Luftfahrt, selbstfahrenden Autos, Zügen oder Schiffen, muss man verstehen, wie sich Fehler im System ausbreiten können. Oft sind diese Systeme zu komplex, um sie manuell zu analysieren, und selbst wenn kritische Komponenten identifiziert werden, ist es schwierig, die vollen Auswirkungen eines Fehlers zu erfassen.

Ziel dieser Arbeit ist es, eine formale Darstellung von Systemen durch „Angriffsgraphen“ zu schaffen, die die Ausbreitung von Fehlern visualisieren. Mithilfe von "Symbolic Execution" wird das Input-/Output-Verhalten jeder Komponente analysiert, und auf der Grundlage ihrer Interaktionen kann ein Graph erstellt werden.

Ziel ist es, ein Werkzeug zur Verfügung zu stellen, das es dem Benutzer ermöglicht, ihm verschiedene Komponenten zu geben, ihre Interaktionen zu definieren und illegale Zustände oder Ausgaben zu spezifizieren. Das Tool führt dann für jede Komponente eine symbolic execution entsprechend dem Datenfluss zwischen ihnen durch, analysiert, ob Eingaben zu illegalen Ausgaben führen, und erstellt einen Angriffsgraphen. Dieser kann dann von Systemingenieuren verwendet werden, um kritische Komponenten und Pfade innerhalb des Systems zu identifizieren und Strategien zu entwickeln, um die Auswirkungen von Fehlern abzuschwächen.
