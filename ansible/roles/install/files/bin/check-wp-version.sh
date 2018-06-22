#!/bin/bash
# Prints the current version of a wordpress container
if [ "$#" -eq 1 ]; then
	docker exec -it $1.fpm sh -c 'wp --allow-root core version'
else
	docker run --rm wordpress-php7.1-fpm-alpine-mod:latest sh -c 'wp --allow-root core version'
fi