# Use Debian Bookworm Slim as base for smaller image size
FROM debian:bookworm-slim

# Define build arguments with defaults for customization
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG GAME_VERSION="0.0.26"
ARG INSTALL_DIR="/game"
ARG BUILD_DATE
ARG VCS_REF
ARG GAME_PORT=20595

# Set environment variables for game runtime configuration
ENV INSTALL_DIR="${INSTALL_DIR}" \
    LANG="C.UTF-8" \
    GAME_VERSION="${GAME_VERSION}" \
    TZ="UTC" \
    DISPLAY=":0" \
    PULSE_SERVER="/run/user/1000/pulse/native" \
    GAME_PORT="${GAME_PORT}" \
    GAME_SETTINGS=""

# Install dependencies with version pinning, additional utilities, and verify Gosu with SHA256
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1=1.6.* \
    libfreetype6=2.11.* \
    libasound2=1.2.* \
    libgbm1=22.* \
    libwayland-client0=1.20.* \
    libpulse0=16.* \
    alsa-utils=1.2.* \
    wget=1.21.* \
    ca-certificates=2023.* \
    procps=2:3.* \
    curl=7.81.* \
    nano=5.8.* \
    pulseaudio=16.* \
    && wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture)" \
    && wget -qO /usr/local/bin/gosu.sha256 "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture).sha256" \
    && echo "$(cat /usr/local/bin/gosu.sha256) /usr/local/bin/gosu" | sha256sum -c - \
    && rm /usr/local/bin/gosu.sha256 \
    && chmod +x /usr/local/bin/gosu \
    && apt-get purge -y wget ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root user and group with specified IDs, adding audio/video groups
RUN groupadd -g "${GROUP_ID}" 0aduser \
    && useradd -u "${USER_ID}" -g 0aduser -m -d /home/0aduser -s /bin/bash 0aduser \
    && usermod -aG audio,video 0aduser \
    && mkdir -p "${INSTALL_DIR}" \
    && chown -R 0aduser:0aduser "${INSTALL_DIR}" /home/0aduser

# Copy game files with explicit ownership
COPY --chown=0aduser:0aduser 0ad-extracted "${INSTALL_DIR}/"

# Create mods directory for user customization
RUN mkdir -p /home/0aduser/.local/share/0ad/mods \
    && chown -R 0aduser:0aduser /home/0aduser/.local/share/0ad/mods

# Copy default mods if provided
COPY --chown=0aduser:0aduser mods /home/0aduser/.local/share/0ad/mods/

# Enhanced healthcheck to monitor game process
HEALTHCHECK --interval=30s --timeout=3s \
    CMD pgrep "0ad" > /dev/null || exit 1

# Expose configurable multiplayer port
EXPOSE "${GAME_PORT}/udp"

# Set working directory and define persistent volumes, including logs
WORKDIR "${INSTALL_DIR}"
VOLUME ["/home/0aduser/.local/share/0ad/", "/home/0aduser/.config/0ad/", "/home/0aduser/.local/share/0ad/logs/"]

# Pre-create config and logs directories with correct permissions
RUN mkdir -p /home/0aduser/.config/0ad /home/0aduser/.local/share/0ad/logs/ \
    && chown -R 0aduser:0aduser /home/0aduser/.config /home/0aduser/.local/share/0ad/logs/

# Copy default configuration file
COPY --chown=0aduser:0aduser config/local.cfg /home/0aduser/.config/0ad/config/

# Verify game binary and create flexible entrypoint script with logging
RUN test -f "${INSTALL_DIR}/usr/bin/0ad" || (echo "Game binary not found" && exit 1) \
    && echo '#!/bin/bash\n\
set -e\n\
echo "Starting 0 A.D. version ${GAME_VERSION}"\n\
exec gosu 0aduser "${INSTALL_DIR}/usr/bin/0ad" -writableRoot "$@"' > /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Set entrypoint to custom script for runtime flexibility
ENTRYPOINT ["/entrypoint.sh"]

# Define default command with common game options and runtime settings
CMD ["-mod=public", "-conf=setting:value", "${GAME_SETTINGS}"]

# Add enhanced metadata labels for better documentation and traceability
LABEL maintainer="yourname@example.com" \
      org.opencontainers.image.title="0 A.D. Game" \
      org.opencontainers.image.version="${GAME_VERSION}" \
      org.opencontainers.image.description="Optimized Docker image for 0 A.D. real-time strategy game" \
      org.opencontainers.image.source="https://github.com/your/repo" \
      org.opencontainers.image.licenses="GPL-2.0" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}"
