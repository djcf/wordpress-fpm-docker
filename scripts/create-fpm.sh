#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Useage: $0 DOMAIN"
    exit 1
fi

#docker create -d \
#	-name $1 \
#-v /var/www/$1/public_html/wp-config.php:/var/www/wp-config.php:ro \
#-v /var/www/$1/public_html:/var/www/wp-content \
#--link sqldb.noflag.org.uk
#	--link switchboard.noflag.org.uk
#	wordpress

# Or:

docker create \
	--name $1 \
	--network vagrant_sql \
	-v docker_web:/usr/share/nginx \
	-v /var/run/docker-apps:/var/run/docker-apps \
	fpm