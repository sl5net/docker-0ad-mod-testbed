#!/bin/bash
# Zeige DISPLAY Variable an
echo "Display Variable: $DISPLAY"

# Stelle sicher, dass die DISPLAY Variable gesetzt ist (falls nicht, versuche :0)
if [ -z "$DISPLAY" ]; then
  export DISPLAY=:0
fi

# Copy default config to volume if it is empty
if [ ! -d "/var/0ad/config/0ad" ]; then
  echo "Copying default config to volume"
  mkdir -p /var/0ad/config/0ad
  cp -r /home/0aduser/.config/0ad/* /var/0ad/config/0ad/
fi

# Copy default mods to volume if it is empty
if [ ! -d "$MODS_VOLUME/public" ]; then
    echo "Copying default mods to volume"
    mkdir -p "$MODS_VOLUME/public"
    cp -r /game/usr/data/mods/* "$MODS_VOLUME/"
fi

# Benutzer zum 0aduser wechseln und das Spiel starten
exec su - 0aduser -c "/game/usr/bin/0ad -writableRoot -config=/var/0ad/config -mod=/var/0ad/mods"
