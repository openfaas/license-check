#!/bin/bash

DOCKER_NS=${DOCKER_NS:-openfaas}
NAME=license-check

if [ ! "$http_proxy" = "" ]
then
    docker build --no-cache --build-arg "https_proxy=$https_proxy" --build-arg "http_proxy=$http_proxy" -t $DOCKER_NS/$NAME:build .
else
    docker build -t $DOCKER_NS/$NAME:build .
fi

docker build --no-cache --build-arg PLATFORM="-ppc64le" -t $DOCKER_NS/$NAME:latest-dev-ppc64le . -f Dockerfile.packager
docker build --no-cache --build-arg PLATFORM="-s390x" -t $DOCKER_NS/$NAME:latest-dev-s390x . -f Dockerfile.packager
docker build --no-cache --build-arg PLATFORM="-darwin" -t $DOCKER_NS/$NAME:latest-dev-darwin . -f Dockerfile.packager
docker build --no-cache --build-arg PLATFORM="-armhf" -t $DOCKER_NS/$NAME:latest-dev-armhf . -f Dockerfile.packager
docker build --no-cache --build-arg PLATFORM="-arm64" -t $DOCKER_NS/$NAME:latest-dev-arm64 . -f Dockerfile.packager
docker build --no-cache --build-arg PLATFORM=".exe" -t $DOCKER_NS/$NAME:latest-dev-windows . -f Dockerfile.packager
docker build --no-cache --build-arg PLATFORM="" -t $DOCKER_NS/$NAME:latest-dev-x86_64 . -f Dockerfile.packager
