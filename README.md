2.  **0 A.D. AppImage herunterladen und extrahieren:**

https://github.com/0ad-matters/0ad-appimage/releases

    ```bash
    ./0ad-0.27.0-linux-x86_64.AppImage --appimage-extract
    mv squashfs-root 0ad-extracted
    ```

3.  **Docker Image (duration maybe 1 minute): **

    ```bash
    docker build -t 0ad .
    ```

4.  **Docker Container ausführen:**

    Führe den Docker Container mit den folgenden Parametern aus:

    ```bash
    xhost +local:docker #Sicherheitshinweis: Besser eine restriktivere Regel verwenden

    docker run --rm -it \
        -e DISPLAY=$DISPLAY \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        --device /dev/snd \
        -e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
        -v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
        -e ALSA_PCM_NAME=default \
        --device /dev/dri \
        --group-add video \
        -v $(pwd)/0ad-extracted:/game \
        0ad
    ```

    **Erläuterung der `docker run`-Parameter:**

    *   `--rm`:  Entfernt den Container automatisch, wenn er beendet wird.
    *   `-it`:  Startet den Container interaktiv.
    *   `-e DISPLAY=$DISPLAY`: Übergibt die DISPLAY-Variable von deinem Host-System an den Container.  Dies ist wichtig, damit das Spiel auf deinem Bildschirm angezeigt wird.
    *   `--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"`:  Mountet den X11-Socket, der für die grafische Anzeige benötigt wird.
    *   `--device /dev/snd`: Aktiviert Audio.
    *   `-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native`, `-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native`, `-e ALSA_PCM_NAME=default`:  Weitere Audio-Konfigurationen (können je nach System variieren).
    *   `--device /dev/dri`: Aktiviert den direkten Rendering Infrastructure (DRI) Zugriff für die Grafikkarte.
    *   `--group-add video`: Fügt den Container zur `video`-Gruppe hinzu, um Zugriff auf die Grafikkarte zu ermöglichen.
    *   `-v $(pwd)/0ad-extracted:/game`:  **Wichtig:**  Mountet das extrahierte 0 A.D. Verzeichnis in den `/game`-Ordner im Container.

    **Sicherheitshinweis (`xhost +local:docker`):**

    Der Befehl `xhost +local:docker` erlaubt es dem Docker-Container, sich mit deinem X-Server zu verbinden.  **Dies kann ein Sicherheitsrisiko darstellen.** Es ist besser, eine restriktivere Regel zu verwenden, wenn möglich.  Alternativ kannst du versuchen, die Berechtigungen für den X-Server anders zu konfigurieren.

## Konfiguration und Mods

*   **Docker Volumes:** Die Konfiguration und Mods werden in Docker Volumes gespeichert.  Das bedeutet, dass sie persistent sind, auch wenn der Container gestoppt oder entfernt wird.
*   **Kein Host-Mounting:** Es werden *keine* Host-Verzeichnisse für die Konfiguration oder Mods gemountet.
*   **Erster Start:** Beim ersten Start des Containers werden die Standardkonfigurationen und Mods in die Volumes kopiert.
*   **Zugriff auf die Volumes:** Um auf die Konfiguration oder Mods zuzugreifen, musst du in den Container einsteigen:

    ```bash
    docker ps  # Um die Container-ID zu finden
    docker exec -it <container_id> bash
    ```

    Innerhalb des Containers findest du die Konfigurationen unter `/var/0ad/config` und die Mods unter `/var/0ad/mods`. Du kannst diese Dateien mit einem Texteditor bearbeiten.

*   **Docker Volume inspizieren:** Um herauszufinden, wo die Daten der Volumes auf dem Host-System gespeichert sind, verwende den Befehl:

    ```bash
    docker volume inspect <volume_name>
    ```

    (Um die Volume-Namen herauszufinden, kannst du `docker volume ls` verwenden.)

## Anpassung

*   **Dockerfile:** Das `Dockerfile` kann angepasst werden, um zusätzliche Pakete zu installieren oder andere Änderungen am Container vorzunehmen.
*   **`docker-entrypoint.sh`:** Das `docker-entrypoint.sh` Skript kann angepasst werden, um das Spiel mit verschiedenen Parametern zu starten oder andere Aktionen beim Start des Containers auszuführen.

## Bekannte Probleme

*   **Audio:** Die Audio-Konfiguration kann je nach System variieren. Wenn du keinen Ton hast, musst du möglicherweise die Audio-Parameter im `docker run`-Befehl anpassen.
*   **Performance:** Die Ausführung von 0 A.D. in einem Docker-Container kann etwas langsamer sein als die direkte Ausführung auf dem Host-System.

## Lizenz

Dieses Projekt ist unter der [MIT Lizenz](LICENSE) lizenziert. (Füge eine `LICENSE`-Datei hinzu, wenn du eine Lizenz hinzufügen möchtest).
```

**Erklärungen:**

*   **Markdown-Formatierung:** Die Datei ist im Markdown-Format geschrieben, das in Git-Repositories weit verbreitet ist.
*   **Schritt-für-Schritt-Anleitung:** Die `README.md` enthält eine klare Schritt-für-Schritt-Anleitung, wie man das Dockerfile benutzt.
*   **Erklärung der Parameter:** Die wichtigsten `docker run`-Parameter werden erklärt.
*   **Sicherheitshinweise:** Der Sicherheitshinweis zu `xhost` wird hervorgehoben.
*   **Konfiguration und Mods:** Der Abschnitt über Konfiguration und Mods erklärt, wie die Docker Volumes verwendet werden und wie man auf die Daten zugreifen kann.
*   **Anpassungsmöglichkeiten:** Die `README.md` weist auf die Möglichkeiten zur Anpassung des Dockerfiles und des `docker-entrypoint.sh` Skripts hin.
*   **Bekannte Probleme:** Die bekannten Probleme (Audio und Performance) werden erwähnt.

Du kannst diese `README.md` verwenden, um anderen zu helfen, dein Projekt zu verstehen und zu verwenden.
