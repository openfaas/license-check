#!/bin/bash

DOCKER_NS=${DOCKER_NS:-teamserverless}
TAG=${TRAVIS_TAG:-latest}
NAME=license-check

docker manifest create $DOCKER_NS/$NAME:$TAG \
  $DOCKER_NS/$NAME:$TAG-darwin \
  $DOCKER_NS/$NAME:$TAG-x86_64 \
  $DOCKER_NS/$NAME:$TAG-armhf \
  $DOCKER_NS/$NAME:$TAG-arm64 \
  $DOCKER_NS/$NAME:$TAG-windows \
  $DOCKER_NS/$NAME:$TAG-s390x \
  $DOCKER_NS/$NAME:$TAG-ppc64le

docker manifest annotate $DOCKER_NS/$NAME:$TAG --arch ppc64le $DOCKER_NS/$NAME:$TAG-ppc64le
docker manifest annotate $DOCKER_NS/$NAME:$TAG --arch s390x $DOCKER_NS/$NAME:$TAG-s390x
docker manifest annotate $DOCKER_NS/$NAME:$TAG --arch arm $DOCKER_NS/$NAME:$TAG-darwin
docker manifest annotate $DOCKER_NS/$NAME:$TAG --arch arm $DOCKER_NS/$NAME:$TAG-armhf
docker manifest annotate $DOCKER_NS/$NAME:$TAG --arch arm64 $DOCKER_NS/$NAME:$TAG-arm64
docker manifest annotate $DOCKER_NS/$NAME:$TAG --os windows $DOCKER_NS/$NAME:$TAG-windows

docker manifest push $DOCKER_NS/$NAME:$TAG
