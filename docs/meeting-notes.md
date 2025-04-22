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



## Kick-Off: 14.04.2025

Angr selber testen: -> Program mti zwei abzweigungen schreiben und selber kompilieren.

Inputs finden => wo wird vom netzwerk gelesen, wo wird ein file / input gelesen und wo werden die daten wieder rausgegeben. Assembly analysieren um den interessanten pfad zu finden. (Angr. Explore slide 81-82)

Sinnvoller start Zugang: Wenn ich bei random function anfange sind ggf register nicht ready. => Zuerst weg zum interessanten entry point suchen, State Speichern. Dann mit diesem state von dort weitermachen.

mich interessiert vorallem recv() und send() 

parallel noch gucken ob instruktionspointer unconstrained ist. => Sicherheitslücken direkt nebenbei entdecken.



