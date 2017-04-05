#!/bin/bash

# Convenience / training script for admins

if [ "$#" -eq 0 ]; then
	echo "This script removes and then re-creates a php-fpm container"
	echo "This is useful for example when updating wordpress or adding a wp-config override"
	echo "As always, do NOT type a fully-qualified DOMAIN name as input"
	echo "Instead, use the primary subDOMAIN key, e.g. 'example' in 'example.noflag.org.uk'"
	echo ""
    echo "Useage: $0 PRIMARY_SUBDOMAIN [TAG=latest]"
    exit 1
fi

DOMAIN="$1"
if [ "$#" -eq 2 ]; then
	TAG="$2"
else
	TAG="latest"
fi

if [ -f "/var/www/$DOMAIN/public_html/wp-config.php" ]; then
	EXTRA_VOL_1="--volume /var/www/$DOMAIN/public_html/wp-config.php:/usr/src/wordpress/wp-config.php:ro"
else
	EXTRA_VOL_1=""
fi
if [ -f "/var/www/$DOMAIN/public_html/wp-config-inc.php" ]; then
	EXTRA_VOL_2="--volume /var/www/$DOMAIN/public_html/wp-config-inc.php:/usr/src/wordpress/wp-config-inc.php:ro"
else
	EXTRA_VOL_2=""
fi

systemctl stop fpm@$DOMAIN.service
docker rm -f $DOMAIN.fpm

docker create \
	--name $DOMAIN.fpm \
	--network docker_sqlnet \
	--hostname=$DOMAIN.noflag.org.uk \
	--env-file /var/www/$DOMAIN/.env \
	$EXTRA_VOL_1 $EXTRA_VOL_2 \
	--volume /etc/ssmtp:/etc/ssmtp:ro \
	--volume /var/run/docker-apps/$DOMAIN:/var/run \
	--volume /var/www/$DOMAIN/public_html/wp-content:/usr/src/wordpress/wp-content \
	--volume /var/www/$DOMAIN/public_html/salts.php:/usr/src/wordpress/salts.php:ro \
	wordpress-php7.1-fpm-alpine-mod:$TAG