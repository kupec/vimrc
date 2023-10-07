#!/bin/bash
set -e

DOCKER_FILES=(tests/Dockerfile.*)

for DOCKERFILE in "${DOCKER_FILES[@]}"; do
    IMAGE="vimtest"
    docker build -t "$IMAGE" -f "$DOCKERFILE" .
    docker run --rm -it --device /dev/fuse --privileged "$IMAGE"
done;

docker image rm test;
echo "SUCCESS"
