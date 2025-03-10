# Docker 0 A.D. Mod Testbed

This project provides a Dockerized environment for running the open-source real-time strategy game 0 A.D., enabling GPU acceleration for improved performance.

## Features

*   Runs 0 A.D. inside a Docker container.
*   Enables GPU acceleration using the NVIDIA Container Toolkit and Vulkan (or OpenGL).
*   Provides a simple start script for easy setup.
*   Uses Docker Volumes for persistent storage of configuration data and mods.

## Prerequisites

*   Manjaro Linux (or a similar distribution)
*   NVIDIA Graphics Card with Proprietary Drivers
*   Docker installed and configured
*   NVIDIA Container Toolkit installed and configured

## Installation

1.  **Install the NVIDIA Container Toolkit:**

    Follow the instructions on the NVIDIA website to install the NVIDIA Container Toolkit: [https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

2.  **Configure Docker:**

    Configure Docker to use the NVIDIA Container Runtime:

    ```bash
    sudo nvidia-ctk runtime configure --runtime=docker
    ```

3.  **Restart the Docker daemon:**

    ```bash
    sudo systemctl restart docker
    ```

4.  **Clone the repository (optional):**

    If you are using this project from a Git repository, clone it first:

    ```bash
    git clone <repository_url>
    cd <repository_directory>
    ```

5.  **Extract the 0 A.D. AppImage:**

    Download the 0 A.D. AppImage and extract it:

    ```bash
    ./0ad-0.27.0-linux-x86_64.AppImage --appimage-extract
    mv squashfs-root 0ad-extracted
    ```

    (Replace `0ad-0.27.0-linux-x86_64.AppImage` with the actual filename of the downloaded AppImage.)

6.  **Build the Docker Image:**

    Navigate to the directory containing the `Dockerfile` and `start_0ad.sh` and build the Docker image:

    ```bash
    docker build -t 0ad .
    ```

7.  **Run the Docker Container:**

    Execute the Docker container with the following parameters:

    ```bash
    xhost +local:docker  # Security Warning: Use a more restrictive rule if possible

    export XDG_RUNTIME_DIR=/run/user/$(id -u)

    ./start_0ad.sh
    ```

    **Explanation of the parameters:**

    *   `xhost +local:docker`: Allows the Docker container to connect to your X server. **Security Warning:** `xhost +local:docker` is somewhat more secure than `xhost +`, but it's still important to understand the security implications.
    *   `export XDG_RUNTIME_DIR=/run/user/$(id -u)`: Sets the `XDG_RUNTIME_DIR` environment variable.
    *   `./start_0ad.sh`: Executes the `start_0ad.sh` script, which contains the `docker run` command.

## Project Structure

*   `Dockerfile`: Contains the instructions for building the Docker image.
*   `start_0ad.sh`: A script that simplifies running the Docker container with the necessary parameters.
*   `0ad-extracted`: (This directory is not part of the repository) This directory contains the extracted contents of the 0 A.D. AppImage.

## Future Goals

*   **Automated Testing:** To enable automated testing for mods, including GUI tests.
*   **Reproducible Builds:** To ensure that mods can be built in a consistent environment.
*   **User-Friendly Configuration:** To provide an easy way to configure the testing environment.

## Contributing

Contributions are welcome! Please submit pull requests or report any issues you find.

thanks to andy!
