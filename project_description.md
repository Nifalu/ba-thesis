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

Fuzzing is a well-established method for finding vulnerabilities and bugs in software. However, due to its brute-force nature and exponential runtime, it is often inefficient to fuzz whole systems. This work attempts to use symbolic execution on (small) components of a system to analyze their input/output behavior and draw graphs of the possible states of each component. Such graphs can give an overview of how a vulnerability in one component affects the security of the whole system, and thus help to prioritize not only fuzzing, but also general efforts to make that component less vulnerable to attack.

### Long Description

**English:**

Fuzzing is a well-known way to find problems in software. However, because it tests for all possible inputs, it is often inefficient to use this method to test an entire system. Symbolic execution is a different approach. It doesn't find vulnerabilities on its own, but it can give us insights into how a program behaves for certain inputs. This helps us determine if there might be a vulnerability.

This work aims to improve fuzzing by providing useful insights on where to start and to create a visual representation, called an "attack graph," of how a component's input or output affects the entire system. This can be useful to identify critical components in a system and prioritize not only fuzzing but also general efforts to make that component less vulnerable to attacks.

The goal is to provide a tool that allows users to input different components, define how they interact with each other and specify a set of illegal outputs, or states.  The tool should then run symbolic execution on each component corresponding to the data flow between them, analyze what inputs lead to an illegal output or resulting state and visualize the results.

**German:**

Fuzzing ist eine bekannte Methode, um Probleme in Software zu finden. Da jedoch alle möglichen Eingaben getestet werden, ist es oft ineffizient, mit dieser Methode ein ganzes System zu testen. Die symbolische Ausführung ist ein anderer Ansatz. Sie findet von sich aus keine Schwachstellen, kann uns aber Aufschluss darüber geben, wie sich ein Programm bei bestimmten Eingaben verhält. So lässt sich feststellen, ob eine Schwachstelle vorhanden sein könnte.

Diese Arbeit zielt darauf ab, das Fuzzing zu verbessern, indem sie nützliche Erkenntnisse darüber liefert, wo man ansetzen sollte, und eine visuelle Darstellung, einen so genannten „Angriffsgraphen“, erstellt, der zeigt, wie sich die Eingabe oder Ausgabe einer Komponente auf das gesamte System auswirkt. Dies kann nützlich sein, um kritische Komponenten in einem System zu identifizieren und Prioritäten zu setzen, nicht nur beim Fuzzing, sondern auch bei allgemeinen Bemühungen, diese Komponente weniger anfällig für Angriffe zu machen.

Ziel ist es, ein Werkzeug bereitzustellen, mit dem der Benutzer verschiedene Komponenten angeben, ihre Interaktion untereinander definieren und eine Reihe von illegalen Ausgaben oder Zuständen angeben kann.  Das Tool sollte dann jede Komponente entsprechend dem Datenfluss zwischen ihnen symbolisch ausführen, analysieren, welche Eingaben zu einer illegalen Ausgabe oder einem illegalen Zustand führen, und die Ergebnisse visualisieren.
