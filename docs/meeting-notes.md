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


#### Todos:
- Zwei Dokumente die meine Arbeit beschreiben. Einmal in kurzform (ca. 5 Sätze) und einmal ausführlicher mit evt. 20 Sätzen.

## Kick-Off 14.04.2025

Getting used to angr... Kleine binaries erstellen mit simplen branches und mit angr analysieren.

#### Questions:
- handle multiple inputs??

## Meeting 1: 24.04.2025

#### Todos:

- Über den CFG von den Ziel states zu den Start States zurück suchen und alle anderen paths zu "avoid" hinzufügen.
  Anschliessend bei der SE von Start zu Ziel die Avoid paths jeweils skippen.

- Verschiedene andere Input/Output methoden testen => solche die auf buffer schreiben, solche die ein pointer speichern oder direkt auf den stack gehen => entsprechend Hooks definieren.

- Wie funktioniert es mit Outputs, die von mehreren Inputs abhängig sind?

#### Findings and Questions:
- explore() avoided schon automatisch unmögliche paths. Allerdings muss man einen CFGEmulated übergeben der anscheinend deutlich länger braucht zum erstellen als ein CFGFast. Wie lange dauert das?
- Ich muss prüfen ob eine Variable ausgegeben wird und dann die constraints dieser Variable weitergeben. Die constraints auf dem Input von Program A sind für Program B gar nicht relevant...

## Meeting 2: 02.05.2025

Übergabe von Output and nächsten Input funktioniert gut. Sieht super aus!

#### Todos:

- Config File integrieren um die Kommunikationswege im System zu definieren
- Manuel Constraints hinzufügen am Ende => schauen welche input constraints sich ändern. Falls sich input constraint ändern, den neuen constraint beim vorherigen Program als Constraint hinzufügen und dort die Inputs kontrollieren. => Art backtracking bis zu den Entry Points.
- Graph zeichnen

#### Findings and Questions:

- D3.js super für Graph Visualisierungen => ReactFlow evt besser für GUI-Based Konfiguration und Analyse...
- Constraint Backtracking nicht ganz einfach. Wenn Constraints nicht stimmen, liegt der Fehler am Component oder am Input?
  - Variante A: Es liegt immer am Component selbst. => Wir müssen für jeden Komponent individuell prüfen, ob die Constraints stimmen.
    - ( - ) Evt. schwierig für einen Mensch, exakte Constraints für einen Component zu definieren? 
    - ( + ) Abweichungen werden sofort erkannt.
- Variante B: Es liegt immer am Input, wir gehen davon aus, dass der Component korrekt implementiert ist. Ausser der Input ist unconstrained (ie. kommt von aussen)
  - B1: Problem wird immer weitergegeben, bis es am Ende von aussen kommt. Es ist immer der ganze Path betroffen. Wir können nicht wirklich eine Aussage machen?
  - B2: Bei mehreren Inputs könnte man Quantifier Elimination machen um Constraints an die individuellen Inputs weiterzugeben... Äusserst aufwändig.

## Meeting 13.05.2025

- Kein Config File => Components (binaries) geben einen "destination" output und kommunizieren auf einem gemeinsamen Canbus. Wir definieren nur, welche Componenten unconstrained input von aussen erhalten, i.e die Leafs vom System. Anhand von denen wird dann automatisch der Tree gebaut.
  - Wird wohl ein Multi-Path Graph oder so brauchen, da eventuell A => B => C und D => B => C existieren, ein möglicher Fehler aber nur bei D => B => C weitergeben wird während A => B => C einwandfrei funktioniert auch bei fehlerhaftem input.
- Pro Component können Output-constraints definiert werden, welche eingehalten werden müssen. Es wird sofort erkannt, wenn ein Component von diesen Abweicht. Und falls dies der Fall ist, können Beispiel Inputs berechnet werden, mit denen dieser Zustand erreicht wird.
- Wenn ein Component von seinen Constraints abweicht, werden die Output Paths markiert. So sieht man schnell, welchen Impact die Abweichung auf das System hat und ob andere Components diese Abweichung wieder auffangen oder weitergeben / verschlimmern.
- Bei Components mit mehreren Inputs werden alle Kombinationen ausprobiert um zu berechnen, wieviele fehlerhafte Inputs es braucht, bis der Component selber Fehler weitergibt.
