(Linux Debian/Ubuntu) - Terminal/Server

Das Texter - Script sendet bei Aufruf eine Zeile aus einer vorher definierter Textdatei an den entsprechenden Benutzer. So lassen sich Automationen bei Crontab-Aufruf mit netten Sprüchen oder Informationen ausgeben.

Es entsteht in der Konfigurationsdatei unter /home/$Benutzer/script-data/texter ein Ordner mit Telegram. Hier sind die Benutzer und deren Chat-ID zu finden. Diese Einrichtung und die Texte-Datei müssen zuerst eingestellt werden.
Die Textdatei kann beliebig lang sein, die Texte sind zeilenweise getrennt.

Es ist zu unterscheiden zwischen Benutzern und dem Master. Der Master ist der Administrator, der auch über Telegram Fehlermeldungen erhält, z. B., wenn keine Texte hinterlegt wurden oder die Texte-Datei zu Ende ist und von vorne beginnt.

Im Hintergrund entsteht ein Protokoll mit Chat-ID/Namen und dem entsprechenden Text zur Fehlerüberprüfung oder ob überhaupt die Nachricht rausgeht.

Mit integriertem Updater, der bei neuerer Version auf dem Server direkt die Bash-File mit der neuen automatisch ersetzt.

Garantiert lauffähig auf Debian und Ubuntu und alle Zwischendistributionen (Xubuntu, Kubuntu, ...)

Nur in Deutsch verfügbar, Umbau auf anderen Sprachen auf Anfrage. Only available in German, conversion to other languages on request.
