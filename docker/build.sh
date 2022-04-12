#!/bin/sh

VERSION=$1
USER=$2
PASSWORD=$3

if [ $# -ne 3 ]; then
  echo 'Usage: ./docker/build.sh <version> <user> <password>, e.g. ./docker/build.sh latest user password'
  exit 1
fi

# login to docker hub
docker login -u "$USER" -p "$PASSWORD"

IMAGE=phzfi/ubuntu32-nginx:$VERSION
LATEST=phzfi/ubuntu32-nginx:latest
echo "Building $IMAGE"

docker build --platform linux/686 -t "$IMAGE" -f Dockerfile . --no-cache
docker tag "$IMAGE" "$IMAGE"
docker tag "$IMAGE" "$LATEST"
docker push "$IMAGE"
docker push "$LATEST"

