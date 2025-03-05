#!/bin/bash

# Sicherheitshinweis: Besser eine restriktivere Regel verwenden
xhost +local:docker

export XDG_RUNTIME_DIR=/run/user/$(id -u)

docker run --rm -it \
    -e DISPLAY="$DISPLAY" \
    -e SDL_VIDEODRIVER=x11 \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --device /dev/snd \
    -e PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native" \
    -v "${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native" \
    -e ALSA_PCM_NAME=default \
    --device /dev/dri \
    --group-add video \
    -v "$(pwd)/0ad-extracted:/game" \
    -v $(pwd)/0ad-extracted/usr/data/mods:/var/0ad/mods \
    0ad

