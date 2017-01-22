#!/bin/bash
docker run -v ~/dev/home:/home -v ~/dev/root:/root -i dev gpg "$@"
