# Flutter Dartpad on Docker

This project allows you to run a local instance of Dartpad using Docker, with the ability to add your own custom packages to the `dart_services`

## Features

*   **Run Dartpad Locally:** Easily run Dartpad on your own machine using Docker and `docker-compose`.
*   **Custom Packages:** Add any additional Flutter packages you need to the `dart_services` container.

## How to Build

To build the Docker images, you will need to have Docker and `docker-compose` installed on your system.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/agusibrahim/dartpad_docker.git
    cd dartpad_docker
    ```
2.  **(Optional) Add Custom Packages:**
    Open the `docker-compose.yml` file and locate the `dart_services` service. In the `build` section, you will find an `args` block with a `PUB_PACKAGE` variable. You can add any additional packages you need here, separated by commas. For example:
    ```yaml
    args:
      PUB_PACKAGE: "intl,styled_widget,your_package"
    ```
3.  **(Optional) Configure IP Address:**
    Open the `docker-compose.yml` file and locate the `dartpad_ui` service. In the `build` section, you will find an `args` block with a `DART_SERVICES_IP` variable. You can change this to match your local IP address. For example:
    ```yaml
    args:
      DART_SERVICES_IP: "your-ip-address:8084"
    ```
4.  **Build and Run:**
    ```bash
    docker compose build
    ```

## How to Run

Once you have built the images, you can run the application using the following command:

```bash
docker compose up
```

This will start all the required services. You can then access Dartpad in your browser at `http://localhost:8066`.

## Services

This project uses the following services:

*   `redis`: A Redis instance for caching.
*   `dart_services`: The Dart backend service that provides analysis, compilation, and formatting.
*   `dartpad_ui`: The Dartpad frontend.
*   `caddy`: A reverse proxy that serves the dartpad frontend
