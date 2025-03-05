FROM debian:bookworm

# ENV Variablen für bequemere Konfiguration
ENV INSTALL_DIR="/game"
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV USERNAME=0aduser

#1. Aktualisieren und benötigte Pakete installieren.
RUN apt-get update && apt-get upgrade -y && \
    apt-get remove --purge libsdl2-2.0-0 libsdl2-dev && \
    apt-get autoremove -y && \
    apt-get install -y \
      libasound2 \
      libdrm2 \
      libgbm1 \
      libfreetype6 \
      libwayland-client0 \
      libx11-6 \
      libx11-xcb1 \
      libgl1 \
      libopenal1 \
      libsdl2-2.0-0 \
      --no-install-recommends

#2. Benutzer und Gruppe erstellen, und Benutzer zur Audio Gruppe hinzufügen
RUN groupadd -g $GROUP_ID $USERNAME && \
    useradd -u $USER_ID -g $USERNAME -m $USERNAME && \
    adduser $USERNAME audio

#3.  Konfigurationsverzeichnis erstellen und Berechtigungen setzen.
RUN mkdir -p /home/$USERNAME/.config/0ad && \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/0ad

#4. Mods-Verzeichnis erstellen und Berechtigungen setzen.
RUN mkdir -p /home/$USERNAME/.local/share/0ad/mods && chown -R $USERNAME:$USERNAME /home/$USERNAME/.local/share/0ad/mods

#5. Volumes definieren (für Konfiguration).
VOLUME /home/$USERNAME/.config/0ad
VOLUME /home/$USERNAME/.local/share/0ad/mods

#6. Startskript erstellen
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
