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

#5. Erstelle eine virtuelle Umgebung und installiere Python-Pakete
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip setuptools wheel && \
    /opt/venv/bin/pip install pyautogui opencv-python Pillow

#4. Kopiere das gesamte extrahierte 0 A.D. Verzeichnis.
COPY 0ad-extracted $INSTALL_DIR

COPY run_0ad_game.py /opt/venv/run_0ad_game.py
RUN chmod +x /opt/venv/run_0ad_game.py

WORKDIR $INSTALL_DIR

#5. Starte das Spiel.
# ENTRYPOINT ["gosu", "0aduser", "/game/usr/bin/0ad", "-writableRoot"]
