FROM debian:bookworm

# ENV Variablen für bequemere Konfiguration
ENV INSTALL_DIR="/game"

#1. Aktualisieren und benötigte Pakete installieren.
RUN apt-get update && apt-get install -y \
  libgl1 \
  libfreetype6 \
  libasound2 \
  libgbm1 \
  libwayland-client0 \
  libpulse0 \
  alsa-utils \
  --no-install-recommends

#2. Benutzer und Gruppe erstellen:
RUN groupadd -g 1000 0aduser && useradd -u 1000 -g 0aduser -m 0aduser

#3. Gosu installieren
RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates && \
    wget -qO /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.17/gosu-$(dpkg --print-architecture)" && \
    chmod +x /usr/local/bin/gosu

#4. Kopiere das gesamte extrahierte 0 A.D. Verzeichnis.
COPY 0ad-extracted $INSTALL_DIR

WORKDIR $INSTALL_DIR

#5. Starte das Spiel.
ENTRYPOINT ["gosu", "0aduser", "/game/usr/bin/0ad", "-writableRoot"]
