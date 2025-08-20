
# How to Run the GrafikRCP Application using Docker

This guide explains how to run the `GrafikRCP` application on a Linux desktop. It uses Docker and Docker Compose to automatically create a compatible environment, so you don't have to worry about installing old libraries or dependencies on your main system.

## Prerequisites

Before you begin, you will need the following:

1.  **A Linux Desktop Environment:** This process relies on X11 for displaying the application's GUI. It should work out-of-the-box on most standard Linux desktop distributions (like Ubuntu, Fedora, Debian, etc.).
2.  **Docker and Docker Compose:** You must have a working installation of Docker.
    *   For installation instructions, please follow the official guide: [Install Docker Engine](https://docs.docker.com/engine/install/)
3.  **The Application Files:** You must have the following three files:
    *   `GrafikRCP` (the application executable)
    *   `Dockerfile` (the instructions to build the environment)
    *   `docker-compose.yml` (the script to run the application)

## Setup

1.  Create a new directory on your computer (e.g., `grafik_app`).
2.  Place the three required files (`GrafikRCP`, `Dockerfile`, and `docker-compose.yml`) inside this directory.

Your folder structure should look like this:

```
grafik_app/
├── docker-compose.yml
├── Dockerfile
└── GrafikRCP
```

## Running the Application

1.  Open a terminal on your Linux system.
2.  Navigate into the directory you created.
    ```bash
    cd /path/to/grafik_app
    ```
3.  Run the following command:
    ```bash
    docker-compose up --build
    ```

That's it! The first time you run this command, Docker will download the necessary base images and build the application environment, which may take a few minutes. Subsequent launches will be much faster.

Once the build is complete, the `GrafikRCP` application window should appear on your screen.

## Troubleshooting

### "cannot open display" Error

If you see an error in the terminal like `cannot open display: :0` or `Gtk-WARNING **: cannot open display`, it means the container could not connect to your desktop's display server.

You can usually fix this by running the following command in your terminal **before** you run `docker-compose up`:

```bash
xhost +local:docker
```

This command grants local Docker containers permission to access your display.

## Stopping the Application

1.  Close the `GrafikRCP` application window.
2.  Go back to the terminal where `docker-compose` is running and press `Ctrl+C` to shut down the container.