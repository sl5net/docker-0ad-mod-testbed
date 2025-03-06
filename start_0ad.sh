#!/bin/bash

# Sicherheitshinweis: Besser eine restriktivere Regel verwenden
xhost +local:docker

docker run --rm -it \
    -e DISPLAY="$DISPLAY" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$(pwd)/0ad-extracted:/game" \
    0ad
