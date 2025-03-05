#!/bin/bash

# Sicherheitshinweis: Besser eine restriktivere Regel verwenden
xhost +local:docker

export DISPLAY=:0
export SDL_VIDEODRIVER=x11
export XDG_RUNTIME_DIR=/run/user/$(id -u)

docker run --rm -it \
    -e DISPLAY="$DISPLAY" \
    -e SDL_VIDEODRIVER="$SDL_VIDEODRIVER" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --device /dev/snd \
    -e PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native" \
    -v "${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native" \
    -e ALSA_PCM_NAME=default \
    --device /dev/dri \
    --group-add video \
    -v "$(pwd)/0ad-extracted:/game" \
    -v 0ad-config:/home/0aduser/.config/0ad \
    -v 0ad-mods:/home/0aduser/.local/share/0ad/mods \
    0ad
