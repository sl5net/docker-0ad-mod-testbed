#!/bin/bash

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker to run this script."
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker daemon is not running. Please start the Docker daemon."
    exit 1
fi

# Enhance security by allowing only the current user to access the X server
xhost +si:localuser:$USER
if ! xhost | grep -q "si:localuser:$USER"; then
    echo "Error: Failed to set X server access. You may need to run 'xhost +si:localuser:$USER' manually."
    exit 1
fi

# Set default environment variables if not already set
if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
fi

if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
fi

if [ -z "$SDL_VIDEODRIVER" ]; then
    export SDL_VIDEODRIVER=x11
fi

if [ -z "$SDL_RENDER_DRIVER" ]; then
    export SDL_RENDER_DRIVER=opengl
fi

if [ -z "$NVIDIA_DRIVER_CAPABILITIES" ]; then
    export NVIDIA_DRIVER_CAPABILITIES=all
fi

if [ -z "$NVIDIA_VISIBLE_DEVICES" ]; then
    export NVIDIA_VISIBLE_DEVICES=all
fi

# Check for necessary devices
if [ ! -e "/dev/snd" ]; then
    echo "Warning: /dev/snd not found. Sound may not work."
fi

if [ ! -e "/dev/dri" ]; then
    echo "Warning: /dev/dri not found. Graphics acceleration may not work."
fi

# Set game directory, default to current directory's 0ad-extracted
GAME_DIR=${GAME_DIR:-$(pwd)/0ad-extracted}
if [ ! -d "$GAME_DIR" ]; then
    echo "Error: Game directory $GAME_DIR does not exist."
    exit 1
fi

# Run the Docker container
docker run --rm -it \
    -e DISPLAY="$DISPLAY" \
    -e SDL_VIDEODRIVER="$SDL_VIDEODRIVER" \
    -e SDL_RENDER_DRIVER="$SDL_RENDER_DRIVER" \
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
    -v "$GAME_DIR:/game" \
    0ad

# Revoke X server access when the script exits
trap "xhost -si:localuser:$USER" EXIT
