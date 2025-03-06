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
  --no-install-recommends

#2. Kopiere das gesamte extrahierte 0 A.D. Verzeichnis.
COPY 0ad-extracted $INSTALL_DIR

WORKDIR $INSTALL_DIR

#3. Starte das Spiel.
ENTRYPOINT ["/game/usr/bin/0ad", "-writableRoot"]
