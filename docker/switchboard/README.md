The switchboard functions as the system's vhost manager.  When a new container is created, docker automatically regenerates the nginx configuration files to add the new vhost using dockergen. nginx loads the requested file from the filesystem if it is a static asset; if the requested asset is a php script a small cache is checked. If the generated page is not found in the cache or if the cache is cold, nginx hands the request to a systemd proxy which wakes up the php fpm container which handles the request.

See more: https://github.com/jwilder/nginx-proxy

The main host's nginx configuration goes here.