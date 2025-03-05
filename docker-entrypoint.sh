#!/bin/bash
# Zeige DISPLAY Variable an
echo "Display Variable: $DISPLAY"

# Stelle sicher, dass die DISPLAY Variable gesetzt ist (falls nicht, versuche :0)
if [ -z "$DISPLAY" ]; then
  export DISPLAY=:0
fi

# Benutzer zum 0aduser wechseln
exec su - 0aduser -c "/game/usr/bin/0ad -writableRoot -config=/home/0aduser/.config/0ad -mod=/home/0aduser/.local/share/0ad/mods"
