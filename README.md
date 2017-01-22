# docker_dev
My dockerized devbox

# Build

```bash
$ cd docker
$ docker build -t dev:latest --rm .
```

# Run

```bash
$ docker run -v ~/dev/home:/home -v ~/dev/root:/root -it dev /bin/bash --login
```