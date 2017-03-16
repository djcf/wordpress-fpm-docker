#!/bin/bash

# Prints a list of sites in the group fpm container
ON_DEMAND_CONTAINERS="/var/lib/docker/volumes/docker_sites_enabled/_data/php-fpm-group"

shopt -s nullglob
for filename in $ON_DEMAND_CONTAINERS/*.conf; do
    domain=${filename%.conf}
    domain=${domain##*/}
    echo $domain
done
