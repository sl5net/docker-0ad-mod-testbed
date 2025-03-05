FROM debian:bookworm

# ENV Variablen für bequemere Konfiguration
ENV INSTALL_DIR="/game"
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV USERNAME=0aduser
ENV CONFIG_VOLUME="/var/0ad/config"
ENV MODS_VOLUME="/var/0ad/mods"

#1. Aktualisieren und benötigte Pakete installieren.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  libasound2 \
  libdrm2 \
  libgbm1 \
  libfreetype6 \
  libwayland-client0 \
  libx11-6 \
  libx11-xcb1 \
  libgl1-mesa-dri \
  libgl1-mesa-glx \
  mesa-utils \
  libopenal1 \
  libsdl2-2.0-0 \
  --no-install-recommends

#2. Benutzer und Gruppe erstellen, um Berechtigungsprobleme zu vermeiden.
RUN groupadd -g $GROUP_ID $USERNAME && \
    useradd -u $USER_ID -g $USERNAME -m $USERNAME

#3. Konfigurationsverzeichnis im Volume erstellen und Berechtigungen setzen.
RUN mkdir -p $CONFIG_VOLUME && \
    chown -R $USERNAME:$USERNAME $CONFIG_VOLUME

#4. Mods-Verzeichnis im Volume erstellen und Berechtigungen setzen.
RUN mkdir -p $MODS_VOLUME && \
    mkdir -p $MODS_VOLUME/public && \ # Das "public" Unterverzeichnis erstellen
    chown -R $USERNAME:$USERNAME $MODS_VOLUME

#5.  Benutzer wechseln.
USER $USERNAME
WORKDIR /game

#6. Volumes definieren (für Konfiguration und Mods).
VOLUME $MODS_VOLUME
VOLUME $CONFIG_VOLUME

#7. Starte das Spiel.
ENTRYPOINT ["/game/usr/bin/0ad", "-writableRoot", "-config=/var/0ad/config", "-mod=/var/0ad/mods"]
