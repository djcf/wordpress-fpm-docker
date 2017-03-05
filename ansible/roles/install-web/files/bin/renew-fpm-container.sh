#!/bin/bash

# Convenience / training script for admins

if [ "$#" -eq 0 ]; then
	echo "This script removes and then re-creates a php-fpm container"
	echo "It's not used automatically, but it can be used if you need to renew/refresh"
	echo "the container, for example after modifying the environment"
	echo ""
	echo "As always, do NOT type a fully-qualified domain name as input"
	echo "Instead, use the primary subdomain key, e.g. 'example' in 'example.noflag.org.uk'"
	echo ""
	echo "Important: Creating the contrainer manually will not by default map extra wp-config or wp-config-inc files"
	echo "This probably isn't a problem, unless you're customizing wp-config"
	echo "If this is a problem for you, just cat this script and ammend the volume mounts"
	echo ""
    echo "Useage: $0 PRIMARY_SUBDOMAIN"
    exit 1
fi

domain=$1

systemctl stop fpm@$domain.service
docker rm -f $domain.fpm

docker create \
	--name $domain.fpm \
	--network docker_sqlnet \
	--hostname=$domain.noflag.org.uk \
	--env-file /var/www/$domain/.env \
	--volume /etc/ssmtp:/etc/ssmtp:ro \
	--volume /var/run/docker-apps/$domain:/var/run \
	-v /var/www/$domain/public_html/wp-content:/usr/src/wordpress/wp-content \
	-v /var/www/$domain/public_html/salts.php:/usr/src/wordpress/salts.php:ro \
	wordpress-php7.1-fpm-alpine-mod