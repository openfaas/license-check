#!/bin/bash

DOCKER_NS=${DOCKER_NS:-openfaas}
TAG=${TRAVIS_TAG:-latest}
NAME=license-check

echo $DOCKER_PASSWORD | docker login -u=$DOCKER_USERNAME --password-stdin;
docker push $DOCKER_NS/$NAME:$TAG-darwin;
docker push $DOCKER_NS/$NAME:$TAG-armhf;
docker push $DOCKER_NS/$NAME:$TAG-arm64;
docker push $DOCKER_NS/$NAME:$TAG-windows;
docker push $DOCKER_NS/$NAME:$TAG-x86_64;
