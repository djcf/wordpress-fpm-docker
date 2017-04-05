#!/bin/bash
IMAGE=wordpress-php7.1-fpm-alpine-mod
CURRENT_VERSION=$(docker run --rm $IMAGE:latest wp --allow-root core version)
docker rmi $IMAGE:old
docker tag $IMAGE:latest $IMAGE:$CURRENT_VERSION
docker tag $IMAGE:latest $IMAGE:old
docker rmi $IMAGE:latest
docker build $LATEST_WP_DIR -t $IMAGE:latest
LATEST_VERSION=$(docker run --rm $IMAGE:latest wp --allow-root core version)
docker tag $IMAGE:latest $IMAGE:$LATEST_VERSION
while read -r container; do
	echo "Updating $container to $LATEST_VERSION"
	/usr/local/bin/renew-fpm-container.sh $container
	docker run --rm --volumes-from $container $IMAGE:latest wp --allow-root core update-db; wp --allow-root plugin update --all
done <<< $(/usr/local/bin/view-on-demand-containers.sh)
# docker rm -f group-wordpress.fpm
# docker-compose up -d -f $group-assembly wordpress