#!/bin/bash
IMAGE=wordpress-php7.1-fpm-alpine-mod
if [ -d /vagrant/docker ]; then
	LATEST_WP_DIR=/vagrant/docker/apps/wordpress
elif [ -d /usr/local/web ]; then
	LATEST_WP_DIR=/usr/local/web/docker/apps/wordpress
elif [ -d "$1" ]; then
	LATEST_WP_DIR="$1"
else
	echo "Could not find installation directory containing docker image"
	echo "Usage: $1 WP_DOCKER_IMAGE_DIRECTORY"
	exit 0
fi

CURRENT_VERSION=$(docker run --rm $IMAGE:latest wp --allow-root core version)
docker rmi $IMAGE:old
docker tag $IMAGE:latest $IMAGE:$CURRENT_VERSION
docker tag $IMAGE:latest $IMAGE:old
docker rmi $IMAGE:latest
docker build --pull $LATEST_WP_DIR -t $IMAGE:latest
LATEST_VERSION=$(docker run --rm $IMAGE:latest wp --allow-root core version)
docker tag $IMAGE:latest $IMAGE:$LATEST_VERSION
docker rm -f group-wordpress.fpm
IFS=" "
while read -r container; do
	echo "Updating $container to $LATEST_VERSION"
	SUBDOMAIN=${container::-4}
	/usr/local/bin/renew-fpm-container.sh $SUBDOMAIN
	docker run --env-file /var/www/$SUBDOMAIN/.env --rm --volumes-from $container --network=docker_sqlnet --link sqldb.noflag.org.uk:sqldb.noflag.org.uk $IMAGE:latest sh -c 'wp --allow-root core update-db; wp --allow-root plugin update --all'
done <<< $(docker ps --all --filter ancestor=wordpress-php7.1-fpm-alpine-mod:old --format "{{.Names}}")

#cd $LATEST_WP_DIR
#cd ../../
#docker-compose up -d wordpress
#while read -r container; do
#	echo "Updating $container to $LATEST_VERSION
#	SUBDOMAIN=${container::-4}
#	docker run --env-file /var/www/$SUBDOMAIN/.env --rm --volumes-from group-wordpress.fpm $IMAGE:latest sh -c 'wp --allow-root core update-db; wp --allow-root plugin update --all'
#done <<< $(/usr/local/bin/view-php-group-websites.sh)
