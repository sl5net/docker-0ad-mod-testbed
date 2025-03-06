```markdown
# Docker 0 A.D. Mod Testbed

This project aims to provide an isolated and reproducible testing environment for developing mods for the open-source real-time strategy game 0 A.D.

## Current Status

Currently, this project enables:

*   Running 0 A.D. inside a Docker container.
*   Easily mounting the extracted 0 A.D. AppImage into the container.
*   Using Docker Volumes for persistent storage of configuration data and mods (in the future).

## Future Goals

The long-term goals of this project are:

*   **Automated Testing:** To enable automated testing for mods, including GUI tests (e.g., using Selenium or Cypress).
*   **Reproducible Builds:** To ensure that mods can be built in a consistent and reproducible environment.
*   **Isolated Development:** To provide an isolated development environment where mod developers can make changes without affecting their host system.
*   **Easy Deployment:** To simplify the deployment of mods for the 0 A.D. community.
*   **CI/CD Integration:** To enable integration with CI/CD (Continuous Integration/Continuous Deployment) pipelines for automated testing and builds of mods.
*   **Support for Different 0 A.D. Versions:** To support different 0 A.D. versions, allowing mods to be tested and developed for specific versions of the game.
*   **User-Friendly Configuration:** To provide an easy way to configure the testing environment, such as through environment variables or configuration files.



```
