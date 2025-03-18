#!/bin/bash

# Function to log messages with timestamps
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Show and check the DISPLAY variable
log "Display Variable: $DISPLAY"
if [ -z "$DISPLAY" ]; then
    log "DISPLAY variable is not set. Attempting to set it to :0"
    export DISPLAY=:0
else
    log "DISPLAY variable is set to: $DISPLAY"
fi

# Verify if the DISPLAY is accessible
if ! xset -q > /dev/null 2>&1; then
    log "Warning: Cannot connect to X server on DISPLAY $DISPLAY. The game may not launch correctly."
fi

# Define the game binary path
GAME_BINARY="/game/usr/bin/0ad"
if [ ! -f "$GAME_BINARY" ]; then
    log "Error: Game binary not found at $GAME_BINARY. Please ensure the game is installed correctly."
    exit 1
fi

# Check if the 0aduser exists
if ! id "0aduser" > /dev/null 2>&1; then
    log "Error: User '0aduser' does not exist. Please create the user or adjust the script."
    exit 1
fi

# Set configuration and mod directories
CONFIG_DIR="/home/0aduser/.config/0ad"
MOD_DIR="/home/0aduser/.local/share/0ad/mods"

# Create directories if they don't exist
mkdir -p "$CONFIG_DIR" "$MOD_DIR"

# Switch to 0aduser and run the game
log "Switching to user '0aduser' and starting the game..."
exec su - 0aduser -c "$GAME_BINARY -writableRoot -config=$CONFIG_DIR -mod=$MOD_DIR"

# Check if the game failed to start
if [ $? -ne 0 ]; then
    log "Error: Failed to start the game. Check the game logs for more information."
    exit 1
fi
