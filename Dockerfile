FROM debian:bookworm

# ENV Variablen für bequemere Konfiguration
ENV INSTALL_DIR="/opt/0ad"
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV USERNAME=0aduser

#1. Aktualisieren und benötigte Pakete installieren.
RUN apt-get update && apt-get install -y \
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

#2. Benutzer und Gruppe erstellen, und Benutzer zur Audio Gruppe hinzufügen
RUN groupadd -g $GROUP_ID $USERNAME && \
    useradd -u $USER_ID -g $USERNAME -m $USERNAME && \
    adduser $USERNAME audio

#3. Gosu installieren
RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates && \
    wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture)" && \
    chmod +x /usr/local/bin/gosu

#4. Kopiere das gesamte extrahierte 0 A.D. Verzeichnis.
COPY 0ad-extracted $INSTALL_DIR

WORKDIR $INSTALL_DIR

#5. Erstelle einen symbolischen Link zur NVIDIA libGL.so
RUN ln -s /usr/lib/libGL.so /usr/lib/nvidia-libGL.so
# Link erstellen

#6. Starte das Spiel als der Benutzer 0aduser
ENTRYPOINT ["gosu", "0aduser", "/opt/0ad/usr/bin/0ad", "-writableRoot"]
