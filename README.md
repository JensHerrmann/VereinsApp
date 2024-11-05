# Vereins Applikation und Datenbank
## VereinsApp

## Zweck und Verwendung der Applikation:
Die DB dient der Verwaltung des Vereins, der Vereinsmitglieder, soll den Verzehr der Mitglieder aus dem öffentlich zugänglichen Kühlschrank abbilden.
Der Einkauf der Artikel bzw die Artikelverwaltung soll optional sein, falls implementiert inklusive Steuerrelevanter Daten zB. Kassenbons. 
Ein Export der Kosten der einzelnen Mitglieder soll möglich sein, so dass eine Bank Datei für die Abbuchung automatisch erstellt werden kann.
Personen von anderen vereinen oder Gäste sollen für Mitglieder verwendbar sein und auch bar abrechenbar für Gäste oder an Spieltagen.
Mitglieder dürfen die Kosten der Gäste bar einnehmen und auf ihr eigenes Konto als Minus einbuchen.
Gast zahlt 2 Euro pro Cola, Fanta, Sprite, Mitglieder zahlen 1,60, was ist mit dem Überschuss?
Bei Turnieren oder an Spieltagen muss für Gäste eine andere Kostenstruktur aktiv sein, als für Vereinsmitglieder. Artikel Preis Mitglieder / Preis Gäste

## Annahmen zur App Verwendung (erweitert)
-> Mitglieder können Verwaltet werden  
-> Gäste können verwaltet werden  
-> Mitglieder buchen selbst auf ihren Verzehrdeckel  
-> Kostenstruktur Mitglieder und Gäste unterschiedlich  
-> Heimatverein und andere Vereine können verwaltet werden  
-> Rücksprache zum Mitglied Fremdverein Telefonnummer Sportwart?  

-> Kennwort geschützte Operationen durch Vorstand:  
-> Abrechnung am Ende des Monats Button Click vom Kassenwart  
-> Push am Ende des Monats in Historientabelle  
-> Erstellung einer Bank Datei für die automatisierte Abrechnung in einer Homebanking Software  
-> Rückbuchung bei Mitglied Konto nicht gedeckt, Kassenwart kann Betrag wieder einbuchen.  
-> Oder alle Artikel mit der letzten bezahlt Buchung wieder auf unbezahlt stellen.  

-> Alle Mitglieder sollen einen Gast abrechnen können.  
-> Abrechnung bei Fremdspielern auf Click am Ende des Tages.  
-> Einnahmen in die Bar Kasse.  

-> Anpassung E-Mail Telefon durch Mitglieder selbst  

-> Ausgesetzte Mitglieder können keinen Verzehr buchen  
-> Ausgesetzte Mitglieder sind nicht Teil der Monatsabrechnung  

-> Mitglieder können sich das Tischgeld bar auszahlen lassen und müssen dafür Tischgeld einbuchen  
   Damit der Verein das Geld darüber zurück bekommt.  

-> Erweiterung der PSG Logik um Einkauf -> Jahresabrechnung einfacher Bons / Kassenzettel usw... Scan / Foto  
-> Gegenüberstellung des Einkaufs und des Mitgliederverkaufs?  
-> Kleine Betrügereien...  

-> Anzeige ob ein Gast oder Mitglied Hausverbot hat  

-> Funktionen Abrechnung / Beitrag Einzug usw... als Logik in der App.  
-> Speicherung der Daten in der DB  
-> Anzeige der zusammenhängenden Daten als Views in der DB  

## Applikation technologisch
Desktop App WPF in C# als Frontend  
SQL DB als Backend  
ODER  
Web App Rest Api .net C# und Blazor Frontend Rest Api Backend  
Daten Backend -> SQL Server DB  

## Tabellen funktional
Tabellen werden nach ihrem Verwendungszweck benannt.  
Jede Tabelle hat eine Id = Primärschlüssel PK -> Id  
Tabellen in Relation haben einen oder mehrere Fremdscchlüssel Foreign Key s FK s.  
Beziehungen werden durch Fremdschlüssel FK_Tabelle dargestellt / benannt  
Personen (FK_Verein) -> (Id) Verein N zu 1 (1 Verein zu N Personen)  
Personen ID -> FK_Personen Verzehr FK_Artikel -> ID Artikel (N zu N Beziehungen = Person 1 zu N Verzehr N zu 1 Artikel)  
Mitglied Funktion Tabelle Funktion FK_Vorstand -> ID Vorstand Präsi, Kassenwart, Sportwart Nixkönner… Gewählt am Datum  
1 zu 1 um selten verwendete Daten auszulagern. Hier eher irrelevant.  

## Tabellenschema:
DB - Entitäten  
Vereine -> Heimatverein  
Personen -> Mitglieder  
Artikel  
Verzehr  
Artikel Kategorie / Typ  
Beitrag  

### Tabelle Personen
|id | Vorname | Nachname | Telefon | E-Mail | Post-Anschrift | Hausverbot | 
|---|---------|----------|---------|--------|----------------|------------|
| 1 | Jens | Herrmann | 03883703367 | jens-herrmann@bumbelbee.net | Heisenbergstraße 75, 55551 Brühl | ja /nein | 
| 2 | Jupp | Zupp | 93847026257 | jupp-zupp@gmail.com |  
| 3 | Müller| vomAnderen | 0554875092 | VanAnderen@hosting.de|

### Tabelle Vereine
| id | Verein | HeimatVerein |
|-|-|-|
1 | PSG | Ja | 
2 | Köln Süd | null | 

### Tabelle Mitglieder
| id | Verein | Mitglied | Beitrag | Schrank |
|-|-|-|-|-|
| 1 | 1 | 1 | 1 | 25|
| 2 | 1 | 2 | 2 | null |

### Tabelle Beitrag
| id | Beitrag | Preis |
|-|-|-:|
| 1 | Vollmitglied | 50 Euro |
| 2 | Halbmitglied | 25 Euro |
| 3 | ausgesetzt | 0 Euro |
| 4 | gesperrt | - 100 Euro |

### Tabelle Verzehr
|id | Person   | Artikel     | Typ        | Preis      | gebucht     | bezahlt    | gebucht durch |
|-|-|-|-|-:|-:|-:|-|
|1  | 1        | Cocke       | Getränke   | 1,40 Euro  | 4.11.2024   | 28.11.2024 | 1 |
|2  | 1        | Fassbrause  | Getränke   | 1,80 Euro  | 6.11.2024   | NULL       | 2 |
|3  | 3        | Tischgeld   | Sonstiges  | 6 Euro     | 9.11.2024   | 9.11.2024  | 1 |

### Tabelle Artikel
| id |Artikel    |Typ   |Preis       |Preis Gast |
|-|-|-|:-|-:|
| 1  |Kölsch     |1     |1,20 Euro   |1,60 Euro |
| 2  |Fassbr.    |1     |1,80 Euro   |2,00 Euro |
| 3  |Tischgeld  |4     |6,00 Euro   |6,00 Euro |

### Tabelle Artikel Typ
|id|ArtikelTyp|
|-|-|
|1|Getränke|
|2|Speisen|
|3|Snacks|
|4|Sonstiges|

### Tabelle Abrechnungen
| id | Abrechnungstag  | Monat      | Jahr |
|-|-|-|-|
| 1  | 29.09.2024      | September  | 2024 |
| 2  | 30.10.2024      | Oktober    | 2024 |
| 3  | 28.11.2024      | November   | 2024 |

### Tabelle Historie
? Summe oder Einzelartikel  
? Jahresabrechnung Summen... Kräht eh kein Han mehr nach  
? Mitglied Artikel Artikel Typ Preis   
? Verkaufsanzahl welcher Artikel  


More to come  
