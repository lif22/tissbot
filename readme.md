# TU Wien TISS Bot
*based on the Selenium-Webdriver wrapper for PowerShell by Adam Driscoll (https://github.com/adamdriscoll/selenium-powershell)*
> Systemvoraussetzungen: Chrome 73 oder höher
## Getting Started
---------------
1. Windows PowerShell als Administrator öffnen, ``Install-Module Selenium`` eingeben und mit ``Enter`` bestätigen
2. Die Datei ``config.json`` mit einem Texteditor bearbeiten und die Werte entsprechend befüllen:
	- ``matrikelnummer``: deine Matrikelnummer
	- ``passwort``: dein TISS-Passwort
	- ``kurs``: die Nummer des Kurses ohne den "." (z.B. 309020)
	- ``semester``: das Semester, welches auf der Prüfungsübersichtsseite in TISS angezeigt wird (muss nicht immer mit dem aktuellen Semester übereinstimmen; z.B. 2018W, 2019S etc.)
	- ``prfgNummer``: wenn zum Zeitpunkt der Anmeldung mehrere Prüfungen offen sind - die wievielte auf der Prüfungsseite angezeigte und anmeldbare Prüfung möchtest du wählen (wenn nur eine vorhanden = 1)
	- ``preferredSlot``: wenn es bei der Anmeldung Slots gibt (wie z.B. bei der mündlichen Mechanik 2 VO Prüfung): den wievielten freien Slot möchtest du haben? (ansonsten = 1)
	- ``sleepTime``: wie aggresiv soll der Bot die Seite aktualisieren? Achtung - nicht übertreiben, ideal sind etwa 350-750ms
	- ``promptBeforeAction``: soll der Bot nach dem Login und vor dem wiederholten neu Laden der Seite noch einmal eine Bestätigung durch den Nutzer abfragen? 0=nein, 1=ja. Bei einem geplanten Lauf des Scripts (siehe geplanter Durchlauf) muss diese Option auf 0 gestellt sein.
3. Datei speichern
4. Rechtsklick auf die Datei ``TissLogin.ps1`` -> Öffnen mit -> Windows PowerShell.
5. Relax - der Bot übernimmt für dich die Anmeldung


## Möglichkeit des geplanten Durchlaufs

Ideal für Prüfungsanmeldungen, die spät am Abend sind oder wenn man nicht zuhause ist. Dafür die Datei ``schedule_registration.ps1`` mit einem Texteditor bearbeiten. Dazu die Uhrzeit Eintrag hinter ``/st`` auf die gewünschte Uhrzeit einstellen (im Idealfall etwa eine halbe Minute vor der Anmeldung) und den Pfad am Ende der Zeile anpassen, sodass er auf deinen Speicherort der Datei ``TissLogin.ps1`` zeigt. Danach die Datei speichern und mit Rechtsklick -> Öffnen mit -> Windows PowerShell starten.

**Achtung:** 
* Sicherstellen, dass in der Datei ``config.json`` die Option ``promptBeforeAction`` auf 0 gestellt ist, sonst wartet das Skript vergeblich auf eine Benutzereingabe.
* in den Einstellungen verhindern, dass der Computer nach einer gewissen Zeit in den Standby/Ruhezustand wechselt (ggf. Netzteil anschließen) - ansonsten wird der Durchlauf nicht ausgeführt.

**Info:**
Der Task kann auch direkt im Task Scheduler von Windows bearbeitet werden. Dazu: ``Windows + R`` -> ``taskschd.msc`` eingeben -> ``Enter``.
