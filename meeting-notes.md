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





## Follow up meeting: DD.MM.YYY