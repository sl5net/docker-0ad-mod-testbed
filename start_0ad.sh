#!/bin/bash

# Sicherheitshinweis: Besser eine restriktivere Regel verwenden
xhost +local:docker

export XDG_RUNTIME_DIR=/run/user/$(id -u)
export SDL_VIDEODRIVER=x11
export SDL_RENDER_DRIVER=opengl
export NVIDIA_DRIVER_CAPABILITIES=all
export NVIDIA_VISIBLE_DEVICES=all

# Get the SDDM authentication socket path
SDDM_AUTH=/tmp/sddm-auth-wf99df98-e035-4217-b998-7ac0cabe77de


docker run --rm -it \
    -e DISPLAY="$DISPLAY" \
    -e SDL_VIDEODRIVER="$SDL_VIDEODRIVER" \
    -e SDL_RENDER_DRIVER=opengl \
    -e NVIDIA_DRIVER_CAPABILITIES="$NVIDIA_DRIVER_CAPABILITIES" \
    -e NVIDIA_VISIBLE_DEVICES=all \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="$SDDM_AUTH:/tmp/sddm-auth" \  # Mount the SDDM auth socket
    -v "$(pwd)/0ad-extracted:/game" \
    0ad

