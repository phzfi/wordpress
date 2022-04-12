#!/bin/sh

ENV=$1
VERSION=$2
USER=$3
PASSWORD=$4

usage() {
	echo 'Usage: ./docker/build.sh <dev|prod> [version] [user] [password], e.g. ./docker/build.sh prod latest user password'
	exit 2
}

# argument parsing
[ $# -lt 1 ] && usage
case "$ENV" in
dev) ;;
prod) [ $# -ne 4 ] && usage ;;
*) usage
esac

echo "Building ${ENV} ${IMAGE}"

# use phz prefix for dev images and phzfi for prod images
if [ "$ENV" = 'dev' ]; then
	IMAGE=phz/ubuntu32-nginx:dev
	docker build --platform linux/386 -t "$IMAGE" -f Dockerfile . --no-cache
else # prod
	IMAGE=phzfi/ubuntu32-nginx:$VERSION
	LATEST=phzfi/ubuntu32-nginx:latest
	docker build --platform linux/386 -t "$IMAGE" -f Dockerfile . --no-cache
	docker login -u "$USER" -p "$PASSWORD"
	docker tag "$IMAGE" "$IMAGE"
	docker tag "$IMAGE" "$LATEST"
	docker push "$IMAGE"
	docker push "$LATEST"
fi
