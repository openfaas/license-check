#!/bin/bash

DOCKER_NS=${DOCKER_NS:-openfaas}
TAG=${TRAVIS_TAG:-latest}
NAME=license-check

docker tag $DOCKER_NS/$NAME:latest-dev-darwin $DOCKER_NS/$NAME:$TAG-darwin;
docker tag $DOCKER_NS/$NAME:latest-dev-armhf $DOCKER_NS/$NAME:$TAG-armhf;
docker tag $DOCKER_NS/$NAME:latest-dev-arm64 $DOCKER_NS/$NAME:$TAG-arm64;
docker tag $DOCKER_NS/$NAME:latest-dev-windows $DOCKER_NS/$NAME:$TAG-windows;
docker tag $DOCKER_NS/$NAME:latest-dev-x86_64 $DOCKER_NS/$NAME:$TAG-x86_64;

