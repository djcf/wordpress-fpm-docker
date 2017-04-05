This directory contains a collection of bash scripts which are used to illustrate important procedural points and can be used by admins for testing.

**autologin.sh** generates a one-time login link valid for an expiry window of one hour. Requires a $primary_subdomain.

**check-wp-version**.sh has two modes of operation. Without arguments, it prints the current wordpress version of `wordpress-php7.1-fpm-alpine-mod:latest`. With arguments, it prints the current version of a wordpress container, e.g.:

    ./check-wp-version test
    4.7.3 (*Prints current version of container named test.fpm belonging to 'test' website*)

**import-database.sh** imports a database to the mysql container. Requires a path to a .env file and an absolute path to an sql dump file. Can use gzipped sql files or plain.

**mem-usage.sh** is a useful one-liner for mapping memory used by a child process. It's actually not related to this sytem since docker does this automatically

**mysql** is a one-line mysql client invoker

**renew-fpm-container.sh** takes the complicated work out of removing and re-producing on-demand php-fpm containers

Known issues: does not map custom wp-config and wp-config-inc files.

**renew-fpm-socket.sh** fixes systemd's communication with the on-demand docker container by removing /var/run/docker-apps/$domain and re-starting the systemd units responsible for that directory

**update-all-wordpress.sh** Updates all wordpress containers and sites to the latest version from http://hub.docker.com/_/wordpress.

**update-single-wordpress.sh**: Experimental script to alter a docker container so that uses a different version of wordpress. If --bleeding, the wordpress source will be grabbed from wordpress.org/latest instead of docker hub. Usage:

    $0 CONTAINER_NAME TAG [--bleeding]
    ./update-single-wordpress.sh test.fpm 4.7.3-php7.1-fpm-alpine

**view-on-demand-containers.sh** simply lists on-demand containers and their kill times. If kill times are outstanding, lists that too. In -q mode, simply prints container names.

**view-php-group-websites.sh** simply lists websites in the group-fpm container

**waitport.sh** and **waitsock.sh** are both used to proxy traffic from systemd, which sits between nginx and php-fpm, into the php-fpm containers