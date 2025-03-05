#!/bin/bash

# Sicherheitshinweis: Besser eine restriktivere Regel verwenden
xhost +local:docker

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export SDL_VIDEODRIVER=x11
export SDL_RENDER_DRIVER=opengl
export NVIDIA_DRIVER_CAPABILITIES=all
export NVIDIA_VISIBLE_DEVICES=all

docker run --rm -it \
    -e DISPLAY="$DISPLAY" \
    -e SDL_VIDEODRIVER="$SDL_VIDEODRIVER" \
    -e SDL_RENDER_DRIVER=opengl \
    -e NVIDIA_DRIVER_CAPABILITIES="$NVIDIA_DRIVER_CAPABILITIES" \
    -e NVIDIA_VISIBLE_DEVICES="$NVIDIA_VISIBLE_DEVICES" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --device /dev/snd \
    -e PULSE_SERVER="unix:${XDG_RUNTIME_DIR}/pulse/native" \
    -v "${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native" \
    -e ALSA_PCM_NAME=default \
    --device /dev/dri \
    --group-add video \
    --gpus all \
    -v "$(pwd)/0ad-extracted:/opt/0ad" \
    -v 0ad-config:/home/0aduser/.config/0ad \
    0ad
