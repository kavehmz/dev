# docker_dev
My dockerized devbox

# Build

```bash
$ cd docker
$ docker build -t --build-arg DATADOG_API_KEY=XYZ dev:latest .
```

# Run

```bash
$ docker run -v ~/dev/home:/home -v ~/dev/root:/root -it dev /bin/bash --login
```