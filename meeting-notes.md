# Meeting Notes:

## Initial Meeting: 25.02.2025

### Attack Surface

aus einer software angriffsoberfläche extrahieren. wo gehen daten rein und raus?

control flow graphs -> datenfluss tracken

=> Attackgraphen zeichnen. 

Verschiedene Systeme tauschen daten aus: zB. Sensoren in einem Flugzeug
Welches System liefert welche Daten an welches anderes System? Was für Inputs bekommt ein System? (zB. GPS Daten) und welche Outputs gibt das System? (zB. Geschwindigkeit), wo fliessen diese Daten hin?



### Modularization

Software auf Funktionen oder Blocks aufsplitten => überprüfen ob es Probleme innerhalb der Funktion gibt. Anschliessend Graph zeichnen und diesen wieder durchlaufen und nach zB. UseAfterFree issues prüfen.



### Fragen

- Gibt es bereits Projekte auf denen ich aufbauen würde? Tools / Umgebungen etc? 





## Follow up meeting: 21.03.2025

Verschiedene Module in zB. Flugzeug / Zug / Schiff etc kommunizieren mit einander. (GPS, Radio, Weather, Sat_Com, Autopilot, Position modul, Route-Planner, Flight-Controller.

Ich möchte für jedes Modul welches Input von aussen erhält (sensoren, communication) herausfinden, welche Outputs es geben kann. Diese Outputs sind dann wiederum Constraints für andere Module die diesen Output als input haben.

Am Ende werden manuell valide oder verbote states definiert die ein Flugzeug o.Ä. haben darf. zB. Steigwinkel darf nicht grösser sein als 20 Grad. Über die Inputs und Outputs der einzelnen module kann ich nachher prüfen, ob es inputs gibt, die zu einem verbotenen State führen und wenn ja, woher diese falschen inputs kommen und mit welcher wahrscheinlichkeit.

So lässt sich am ende abschätzen, ob zum Beispiel ein faulty gps sensor einen grossen einfluss auf den Flug-controller hat oder ob dort noch so viele andere module faulty sein müssen um am ende tatsächlich den flugzeug status zu verändern.


#### TODOs:
- Zwei Dokumente die meine Arbeit beschreiben. Einmal in kurzform (ca. 5 Sätze) und einmal ausführlicher mit evt. 20 Sätzen.



## Kick-Off 14.04.2025

Getting used to angr... Kleine binaries erstellen mit simplen branches und mit angr analysieren.

#### Questions:
- handle multiple inputs??

## Meeting 1: 24.04.2025

Über den CFG von den Ziel states zu den Start States zurück suchen und alle anderen paths zu "avoid" hinzufügen.
Anschliessend bei der SE von Start zu Ziel die Avoid paths jeweils skippen.

Verschiedene andere Input/Output methoden testen => solche die auf buffer schreiben, solche die ein pointer speichern oder direkt auf den stack gehen => entsprechend Hooks definieren.

Wie funktioniert es mit Outputs, die von mehreren Inputs abhängig sind?

