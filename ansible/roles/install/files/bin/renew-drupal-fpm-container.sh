#!/bin/bash

# Convenience / training script for admins

if [ "$#" -eq 0 ]; then
        echo "This script removes and then re-creates a php-fpm container"
        echo "This is useful for example when updating drupal or adding an override (not supported or actually needed yet)"
        echo "As always, do NOT type a fully-qualified DOMAIN name as input"
        echo "Instead, use the primary subDOMAIN key, e.g. 'example' in 'example.common.scot'"
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

systemctl stop fpm@$DOMAIN.service
docker rm -f $DOMAIN.fpm

docker create \
        --name $DOMAIN.fpm \
        --network docker_sqlnet \
        --hostname=fpm.$DOMAIN.common.scot \
        --env-file /var/www/$DOMAIN/.env \
        --volume /etc/ssmtp:/etc/ssmtp:ro \
        --volume /var/run/docker-apps/$DOMAIN:/var/run \
        --volume /var/www/$DOMAIN/public_html/private:/buildkit/app/private \
        --volume /var/www/$DOMAIN/public_html/sites:/var/www/html/sites \
        --volume /var/www/$DOMAIN/public_html/scripts:/var/www/scripts/common \
        drupal7-php7.1-fpm-alpine-mod:$TAG
