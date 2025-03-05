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
if [ ! -d "/var/0ad/mods/0ad" ]; then
    echo "Copying default mods to volume"
    mkdir -p /var/0ad/mods/0ad
    cp -r /home/0aduser/.local/share/0ad/mods/* /var/0ad/mods/0ad/
fi

# Starte 0 A.D.
/game/usr/bin/0ad -writableRoot -config=/var/0ad/config -mod=/var/0ad/mods
