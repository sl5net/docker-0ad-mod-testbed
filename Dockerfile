# Use Debian Bookworm as the base image for stability
FROM debian:bookworm

# Define build arguments for configurable user and group IDs
ARG USER_ID=1000
ARG GROUP_ID=1000

# Set environment variables for easier configuration
ENV INSTALL_DIR="/game"
ENV LANG=C.UTF-8

# Install dependencies and Gosu in a single layer to reduce image size
RUN apt-get update && apt-get install -y \
    libgl1 \
    libfreetype6 \
    libasound2 \
    libgbm1 \
    libwayland-client0 \
    libpulse0 \
    alsa-utils \
    wget \
    ca-certificates \
    --no-install-recommends && \
    wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture)" && \
    chmod +x /usr/local/bin/gosu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user and group with configurable IDs
RUN groupadd -g ${GROUP_ID} 0aduser && useradd -u ${USER_ID} -g 0aduser -m 0aduser

# Copy the extracted 0 A.D. game files
COPY 0ad-extracted ${INSTALL_DIR}

# Set permissions and verify the game binary exists
RUN chown -R 0aduser:0aduser ${INSTALL_DIR} && \
    [ -f "${INSTALL_DIR}/usr/bin/0ad" ] || (echo "Game binary not found" && exit 1)

# Set the working directory
WORKDIR ${INSTALL_DIR}

# Define a volume for persistent save data and user-specific files
VOLUME ["/home/0aduser/.local/share/0ad/"]

# Start the game as the non-root user with Gosu
ENTRYPOINT ["gosu", "0aduser", "/game/usr/bin/0ad", "-writableRoot"]

# Add metadata labels for better image documentation
LABEL maintainer="yourname@example.com" \
      version="1.0" \
      description="Docker image for running the 0 A.D. game"
