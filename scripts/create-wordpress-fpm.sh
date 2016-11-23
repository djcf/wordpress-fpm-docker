#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Useage: $0 DOMAIN"
    die()
fi

mkdir -p /var/www/$1/public_html/wp-content
cp ../apps/wprdpress/wp-config.php /var/www/$1/public_html

#docker create -d \
#	-name $1 \
#-v /var/www/$1/public_html/wp-config.php:/var/www/wp-config.php:ro \
#-v /var/www/$1/public_html:/var/www/wp-content \
#--link sqldb.noflag.org.uk
#	--link switchboard.noflag.org.uk
#	wordpress

# Or:

docker create -d \
	-name $1 \
	-v /var/www/$1/public_html/wp-config.php:/var/www/wp-config.php:ro \
	-v /var/www/$1/public_html:/var/www/wp-content \
	--ipc="container:switchboard.noflag.org.uk" \
	--network vagrant_sql \
	wordpress