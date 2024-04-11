## Build the Docker Image Locally
The application can be built & ran locally as below once you are in the app directory
`docker build -t devopsjourneyapp .`

The `-t` is for the tag (the name) of the Docker image and the `.` is telling the Docker CLI that the Dockerfile is in the current directory

After the Docker image is created, run the following command to confirm the Docker image is on your machine.
`docker image ls`

## Run The Docker Image Locally
Now that the Docker image is created, you can run the container locally just to confirm it'll work and not crash.

1. To run the Docker container, run the following command:
`docker run -tid devopsjourneyapp`

- `t` stands for a TTY console
- `i` stands for interactive
- `d` stands for detach so your terminal isn't directly connected to the Docker container

2. To confirm the Docker container is running, run the following command:
`docker container ls`

You should now see the container running.