#!/bin/bash

# Generate a one-use autologin for Wordpress

if [ "$#" -eq 0 ]; then
    echo "Generates a single-use auto-login for wordpress"
    echo ""
    echo "Useage: $0 PRIMARY_SUBDOMAIN"
    exit 1
fi
# Store private signing key
source /var/www/$1/.env

# Figure out the validity window in unix and human form
DATE=$(date -d "1 hour" +%s) # Use this for unix
#DATE=$(date -d "-1 hour" +%s) # Use this for testing (1hr in the past)
HDATE=$(date "+%H:%M:%S %d/%m/%Y" -d  "+1 hour") # Use this for humans

# Possibile ways to generate the token:
# 1: Use openssl to symetrically crypt (rather than sign) the date (more elegent)
#PASS=$(echo -n $DATE | openssl enc -aes256 -nopad -nosalt -k $KEY | sed 's/^.* //')
# 2: Textbook hmac signing using openssl (best):
TOKEN=$(echo -n $DATE | openssl dgst -sha256 -hmac "$MYSQL_PWD" | sed 's/^.* //')
# 3: Use php's hmac function within the wordpress container to guarantee that the same cypher algorithm is used
#PASS=$(echo '<?= hash_hmac("sha1", "$DATE", "$KEY") ?>' | php)

docker cp /var/lib/wordpress/autologin.php $1.fpm:/usr/src/wordpress/autologin.php

RC=$?

if [ "$SSL_HOST" == "ON" ]; then
	SCHEME="https"
else
	SCHEME="http"
fi

if [ $RC == 0 ]; then
	echo "Generated one-time login link."
        echo "It will expire in 1 hour (at $HDATE)."
	echo ""
	echo "$SCHEME://$HTTP_HOST/autologin.php?valid=$DATE&token=$TOKEN"
fi

exit $rc