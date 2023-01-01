#!/bin/bash

user=$(whoami)
data="/home/$user/script-data/texter"
zeitstempel=$(date +"%Y-%m-%d;%H:%M")
datum_bup=$(date +"%Y%m%d%H%M")

# Updater & Reverse Updater BEGINN
if [ "$1" = "update" ]; then
	scriptversion=2301011604
	scriptname=texter.sh
	serverping=public.mariobeh.de
	web_ver=https://public.mariobeh.de/prv/scripte/$scriptname-version.txt
	web_mirror=https://public.mariobeh.de/prv/scripte/$scriptname
	int_ver=/srv/web/prv/scripte/$scriptname-version.txt
	int_mirror=/srv/web/prv/scripte/$scriptname
	host=$(hostname)
	
	if ping -w 1 -c 1 "$serverping" > /dev/null; then
		wget "$web_ver" -q -O "$data/version.txt"
		if [ -f "$data/version.txt" ]; then
			serverversion=$(cat "$data/version.txt" | head -n1 | tail -n1)
			if [ "$serverversion" -gt "$scriptversion" ]; then
				clear
				echo "Eine neue Version von $scriptname ist verfügbar."
				echo ""
				echo "Deine Version: $scriptversion"
				echo "Neue Version:  $serverversion"
				echo ""
				echo "Script wird automatisch aktualisiert, um immer das beste Erlebnis zu bieten."
				echo ""
				sleep 3
				wget -q -N "$web_mirror"
				echo "Fertig. Starte..."
				sleep 2
				$0
				exit
			else
				ipweb=$(host public.mariobeh.de | grep -w address | cut -d ' ' -f 4) # IP vom Mirror-Server
				ipext=$(wget -4qO - icanhazip.com) # IP vom Anschluss
		
				if [ "$user" = "mariobeh" ] && [ "$host" = "behserver" ] && [ "$ipweb" = "$ipext" ]; then
					if [ ! -f "$int_ver" ]; then
						clear
						echo "Internes Reverse Update wird vorbereitet:"
						echo "Kopiere auf das Webverzeichnis..."
						echo "$scriptversion" > "$int_ver"
						cp "$scriptname" "$int_mirror"
						echo "Fertig."
						sleep 2
					elif [ "$scriptversion" -gt "$serverversion" ]; then
						clear
						echo "Internes Reverse Update wird durchgeführt..."
						sleep 2
						echo "$scriptversion" > "$int_ver"
						cp -f $0 "$int_mirror"
						wget "$web_ver" -q -O "$data/version.txt"
						serverversion=$(cat "$data/version.txt" | head -n1 | tail -n1)
						if [ "$serverversion" = "$scriptversion" ]; then
							echo "Update erfolgreich abgeschlossen."
						else
							echo "Update fehlgeschlagen."
						fi
						sleep 2
					fi
				fi
			fi
			rm "$data/version.txt"
		fi
	fi
	echo "Aktueller Stand."
	exit
fi
# Updater & Reverse Updater ENDE

if [ ! -d "$data" ]; then
	mkdir -p "$data"
fi

if [ ! -d "$data/texte" ]; then
	mkdir "$data/texte"
fi

if [ ! -d "$data/telegram" ]; then
	mkdir "$data/telegram"
fi

if [ ! -d "$data/counter" ]; then
	mkdir "$data/counter"
fi

if [ -z "$1" ]; then
	echo "Keine Option angegeben - Abbruch."
	exit
fi

# ANTWORT BEGINN
if [ "$1" = "antwort" ]; then
	if [ ! -d "$data/temp" ]; then
		mkdir "$data/temp"
	fi

	BOT_TOKEN=$(cat "$data/telegram/bottoken.txt" | head -n1 | tail -n1)
	telegram_masterid=$(cat "$data/telegram/master.txt" | head -n1 | tail -n1)
	wget https://api.telegram.org/bot$BOT_TOKEN/getUpdates -O "$data/temp/01-telegram-antwort.txt"
	zeilenanz_antwort=$(sed $= -n "$data/temp/01-telegram-antwort.txt")
	zeile_antwort=$(cat "$data/temp/01-telegram-antwort.txt" | head -n$zeilenanz_antwort | tail -n1)
	echo "$zeile_antwort" > "$data/temp/02-telegram-antwort-zeile.txt"
	cat "$data/temp/02-telegram-antwort-zeile.txt" | sed "s:,: :g ; s/:/ /g ; s/\"/ /g ; s:{::g ; s:}::g ; s:   : :g ; s:  : :g ; s:]::g ; s/\([A-Z]\)/\L\1/g" > "$data/temp/03-telegram-antwort-zeile-sed.txt"
	antwort_id=$(cat "/home/mariobeh/script-data/texter/temp/03-telegram-antwort-zeile-sed.txt" | cut -d ' ' -f 18)
	antwort_nam_a=$(cat "/home/mariobeh/script-data/texter/temp/03-telegram-antwort-zeile-sed.txt" | cut -d ' ' -f 20)
	antwort_nam_b=$(cat "/home/mariobeh/script-data/texter/temp/03-telegram-antwort-zeile-sed.txt" | cut -d ' ' -f 22)
	antwort_name=$(echo $antwort_nam_a $antwort_nam_b)

	text_alt=$(cat "$data/temp/11-telegram-antwort.txt" | head -n1 | tail -n1)
	echo "$antwort_id;$antwort_text" > "$data/temp/12-telegram-antwort.txt"
	text_neu=$(cat "$data/temp/12-telegram-antwort.txt" | head -n1 | tail -n1)

	id_alt=$(cat "$data/temp/21-telegram-id.txt" | head -n1 | tail -n1)
	echo "$antwort_id" > "$data/temp/22-telegram-id.txt"
	id_neu=$(cat "$data/temp/22-telegram-id.txt" | head -n1 | tail -n1)

#	if [ "$text_neu" != "$text_alt" ] && [ "$id_neu" != "$id_alt" ]; then
#		echo "$zeitstempel;$1;$antwort_id;$antwort_name;$antwort_text" >> "$data/Protokoll.csv"
#		if [ "$antwort_text" = "stop " ]; then
#			curl -s --data "text=Servus! Du pausierst nun die Sprüche. Wenn Du wieder weitermachen willst, antworte einfach 'weiter'." --data "chat_id=$antwort_id" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
#			curl -s --data "text=$antwort_name: $antwort_text" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
#		fi
#		if [ "$antwort_text" = "weiter " ]; then
#			curl -s --data "text=Servus! Vielen Dank für die Wiederaufnahme, die Texte laufen weiter." --data "chat_id=$antwort_id" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
#			curl -s --data "text=$antwort_name: $antwort_text" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
#		fi
#		if [ "$antwort_text" = "hallo " ]; then
#			nummer=$(shuf -i 100-999 -n1)
#			curl -s --data "text=Servus! Vielen Dank für die Teilnahme, du läufst nun im Protokoll auf und wirst vom Administrator hinzugefügt. Deine Nummer für die Botänderung ist $nummer. Du kannst jederzeit den Bot anhalten, wenn Du keine Texte mehr erhalten willst. Botprogrammierung grundsätzlich: 'stop' für die vorübergehende Aussetzung der Texte. 'weiter' für das Fortsetzen. Für die genaue Zeichensetzung benötigst du deine Nummer, die du zu Beginn erhalten hast. Die Befehle lauten hierbei '$nummer stop' für die Person Nr. $nummer. Genau dasselbe für die Wiederaufnahme: '$nummer weiter'." --data "chat_id=$antwort_id" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
#			curl -s --data "text=$antwort_name: $antwort_text ($nummer)" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
#		fi
#	else
#		exit
#	fi

	cp "$data/temp/12-telegram-antwort.txt" "$data/temp/11-telegram-antwort.txt"
	cp "$data/temp/22-telegram-id.txt" "$data/temp/21-telegram-id.txt"

# Zugänge legen - z. B. 14 stop = Caro sagt stop. Oder 67 weiter = Martin weiter. PIN oder zusätzl. zum Namen. z. B. Caro 14 stop
# Abfrage per Crontab jede Minute - Ausführung nur, wenn neue Meldungen vorliegen. z. B. letzte Meldung ignorieren
# Stop-Stempel separieren in stop/
# if [ "$antwort_id" = "$telegram_masterid" ] - nur der Master darf Befehle senden

#	rm -r "$data/temp"
fi
# ANTWORT ENDE

if [ ! -z "$1" ] && [ ! "$1" = "antwort" ] && [ ! -f "$data/stop-$1.txt" ]; then

# Telegram Bot Prüfung BEGINN
	if [ ! -f "$data/telegram/bottoken.txt" ]; then
		echo "Fehler! Bitte erst den Bot und den Token festlegen, damit überhaupt eine Nachricht gesendet werden kann!"
		echo "Leere Datei wird erstellt, bitte Bot:Token eintragen!"
		touch "$data/telegram/bottoken.txt"
		echo "$zeitstempel;$1;Fehler: Bot:Token fehlt" >> "$data/Protokoll.csv"
		exit
	else
		BOT_TOKEN=$(cat "$data/telegram/bottoken.txt" | head -n1 | tail -n1)
		if [ -z "$BOT_TOKEN" ]; then
			echo "Fehler! Bitte erst den Bot und den Token festlegen, damit überhaupt eine Nachricht gesendet werden kann!"
			echo "Leere Datei wurde bereits erstellt, bitte Bot:Token eintragen!"
			echo "$zeitstempel;$1;Fehler: Bot:Token fehlt #2" >> "$data/Protokoll.csv"
			exit
		fi
	fi
# Telegram Bot Prüfung ENDE

# Telegram Master Prüfung BEGINN
	if [ ! -f "$data/telegram/master.txt" ]; then
		echo "Fehler! Bitte den Master festlegen, damit Fehlermeldungen an den Master per Telegram versendet werden können!"
		echo "Leere Datei wird erstellt, bitte die Chat-ID vom Master eintragen!"
		touch "$data/telegram/master.txt"
		echo "$zeitstempel;$1;Fehler: Master Chat ID fehlt" >> "$data/Protokoll.csv"
		exit
	else
		telegram_masterid=$(cat "$data/telegram/master.txt" | head -n1 | tail -n1)
		if [ -z "$telegram_masterid" ]; then
			echo "Fehler! Bitte den Master festlegen, damit Fehlermeldungen an den Master per Telegram versendet werden können!"
			echo "Leere Datei wurde bereits erstellt, bitte die Chat-ID vom Master eintragen!"
			echo "$zeitstempel;$1;Fehler: Master Chat ID fehlt #2" >> "$data/Protokoll.csv"
			exit
		fi
	fi
# Telegram Master Prüfung ENDE

	if [ ! -f "$data/telegram/$1.txt" ] && [ ! -f "$data/texte/$1.txt" ]; then
		curl -s --data "text=Fehler bei der Ausführung des Sprüche-Scripts! Es ist für '$1' keine Telegram-ID UND keine Texte-Datei vorhanden! Es werden die beiden Dateien leer angelegt, bitte in die telegram-$1.txt die Chat-ID einfügen und in die texte-$1.txt die Texte zeilenweise einfügen!" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
		echo "$zeitstempel;$1;Fehler: Telegram ID und Texte fehlen" >> "$data/Protokoll.csv"
		touch "$data/telegram/$1.txt"
		touch "$data/texte/$1.txt"
		exit
	fi

# Telegram-Prüfung BEGINN

	if [ ! -f "$data/telegram/$1.txt" ]; then
		curl -s --data "text=Fehler bei der Ausführung des Sprüche-Scripts! Es ist für '$1' keine Telegram-ID vorhanden! Eine leere Datei wird angelegt, bitte die Chat-ID vom Ziel einfügen!" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
		echo "$zeitstempel;$1;Fehler: Telegram ID fehlt" >> "$data/Protokoll.csv"
		touch "$data/telegram/$1.txt"
		exit
	else
		telegram_id=$(cat "$data/telegram/$1.txt" | head -n1 | tail -n1)
		if [ -z $telegram_id ]; then
			curl -s --data "text=Fehler bei der Ausführung des Sprüche-Scripts! Es ist für '$1' keine Telegram-ID vorhanden! Eine leere Datei wurde bereits angelegt, bitte die Chat-ID vom Ziel einfügen!" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
			echo "$zeitstempel;$1;Fehler: Telegram ID fehlt #2" >> "$data/Protokoll.csv"
			exit
		fi
	fi
# Telegram-Prüfung ENDE

# Texte-Prüfung BEGINN
	if [ ! -f "$data/texte/$1.txt" ]; then
		curl -s --data "text=Fehler bei der Ausführung des Sprüche-Scripts! Es ist für '$1' keine Texte-Datei vorhanden! Eine leere Datei wird angelegt, bitte Texte zeilenweise einfügen!" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
		echo "$zeitstempel;$1;Fehler: Texte fehlen" >> "$data/Protokoll.csv"
		touch "$data/texte/$1.txt"
		exit
	else
		texte=$(cat "$data/texte/$1.txt" | head -n1 | tail -n1)
		if [ -z "$texte" ]; then
			curl -s --data "text=Fehler bei der Ausführung des Sprüche-Scripts! Es ist für '$1' keine Texte-Datei vorhanden! Eine leere Datei wurde bereits angelegt, bitte Texte zeilenweise einfügen!" --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
			echo "$zeitstempel;$1;Fehler: Texte fehlen #2" >> "$data/Protokoll.csv"
			exit
		fi
	fi
# Texte-Prüfung ENDE

	z_anzahl=$(sed $= -n "$data/texte/$1.txt")

	if [ ! -f "$data/counter/$1.txt" ]; then
		echo "1" > "$data/counter/$1.txt"
	fi

	z_nummer=$(cat "$data/counter/$1.txt" | head -n1 | tail -n1)
	ausgabe=$(head -n $z_nummer "$data/texte/$1.txt" | tail -n1)

	curl -s --data "text=$ausgabe" --data "chat_id=$telegram_id" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
	echo "$zeitstempel;$1;$z_nummer von $z_anzahl;$ausgabe" >> "$data/Protokoll.csv"

	if [ "$z_nummer" -lt "$z_anzahl" ]; then
		echo $((z_nummer + 1)) > "$data/counter/$1.txt"
	fi

	if [ "$z_nummer" -eq "$z_anzahl" ]; then
		rm "$data/counter/$1.txt"
		curl -s --data "text=Texte bei '$1' zuende, Neuanlauf." --data "chat_id=$telegram_masterid" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
		echo "$zeitstempel;$1;Texte ENDE" >> "$data/Protokoll.csv"
	fi

	find $data/*/* -mmin +1440 -type f -name *.txt -size 0c -exec rm {} \;
fi

#find $data/bup* -mtime +7 -type f -name bup* #-exec rm {} \;
#tar --exclude=$data/bup* -cpf $data/bup-$datum_bup.tar "$data"