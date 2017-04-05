#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Alter a wordpress container so that it uses a specific version of wordpress"
    echo "This is broadly not possible with the group-fpm container"
    echo "See https://hub.docker.com/_/wordpress for valid values"
    echo "Must choose tags of base image wordpress-php-fpm"
    echo "If --bleeding is the last arg, the latest version of WP is fetched from wordpress.org instead of docker hub"
    echo "This is likely to be more recent than the official docker images"
    echo ""
    echo "Useage: $0 CONTAINER_NAME TAG [--bleeding]"
    echo "Example: ./update-single-wordpress.sh test 4.7.3-php7.1-fpm-alpine"
    echo "Example: ./update-single-wordpress.sh test 4.7.3-php7.1-fpm-alpine --bleeding"
    exit 1
fi

IMAGE=wordpress-php7.1-fpm-alpine-mod
TAG="$2"
HUB_TAG="$2"
CONTAINER_NAME="$1"
EXTRA_ARGS=""

if [ "$3" == "--bleeding" ]; then
	TAG="edge"
	EXTRA_ARGS="--build-arg EDGE=TRUE"
fi

docker build $LATEST_WP_DIR -t $IMAGE:$TAG --build-arg TAG=$HUB_TAG $EXTRA_ARGS
NEW_VERSION=$(docker run --rm $IMAGE:$TAG wp --allow-root core version)
OLD_VERSION=$(docker exec -it $CONTAINER_NAME.fpm sh -c 'wp --allow-root core version')

echo "Updating $container ($OLD_VERSION) to $NEW_VERSION"
/usr/local/bin/renew-fpm-container.sh $container
docker run --env-file /var/www/$container/.env --rm --volumes-from $container.fpm $IMAGE:$TAG sh -c 'wp --allow-root core update-db; wp --allow-root plugin update --all'
docker tag $IMAGE:$TAG $IMAGE:$NEW_VERSION