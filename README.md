(Linux Debian/Ubuntu) - Terminal/Server

Für dieses Script ist ein Telegram-Bot Voraussetzung.

Das Texter - Script sendet bei Aufruf eine Zeile aus einer vorher definierter Textdatei an den entsprechenden Benutzer. So lassen sich Automationen bei Crontab-Aufruf mit netten Sprüchen oder Informationen ausgeben.

Es entsteht in der Konfigurationsdatei unter /home/$Benutzer/script-data/texter ein Ordner mit Telegram. Hier sind die Benutzer und deren Chat-ID zu finden. Diese Einrichtung und die Texte-Datei müssen zuerst eingestellt werden.
Die Textdatei kann beliebig lang sein, die Texte sind zeilenweise getrennt.

Es ist zu unterscheiden zwischen Benutzern und dem Master. Der Master ist der Administrator, der auch über Telegram Fehlermeldungen erhält, z. B., wenn keine Texte hinterlegt wurden oder die Texte-Datei zu Ende ist und von vorne beginnt.

Im Hintergrund entsteht ein Protokoll mit Chat-ID/Namen und dem entsprechenden Text zur Fehlerüberprüfung oder ob überhaupt die Nachricht rausgeht.

GEPLANT sind die Benutzereigenen Steuerungen, wenn ein STOP am auszuführenden Telegram-Bot empfangen wird, kann der Benutzer die Texte aussetzen oder deaktivieren und/oder mit START wieder beginnen.

Mit integriertem Updater, der bei neuerer Version auf dem Server direkt die Bash-File mit der neuen automatisch ersetzt.

Garantiert lauffähig auf Debian und Ubuntu und alle Zwischendistributionen (Xubuntu, Kubuntu, ...)

Nur in Deutsch verfügbar, Umbau auf anderen Sprachen auf Anfrage. Only available in German, conversion to other languages on request.


STARTEN:
./texter.sh name --> es entsteht unter script-data/texte, als auch unter script-data/telegram ein Ordner mit diesem Namen. Telegram Chat-ID unter telegram/name.txt setzen und die Texte zeilenweise unter texte/name.txt eingeben. Nach dieser Einrichtung geht eine Nachricht aus der texte/name.txt an die jeweilige Chat-ID.

Automation via Crontab möglich.
