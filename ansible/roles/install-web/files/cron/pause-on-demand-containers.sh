#!/bin/bash

# Pauses on-demand containers after a certain time
# Run by cron
# See https://labs.noflag.org.uk/Noflag/web-two-point-oh/src/master/docs/1.2-On-Demand-Containers.md

ON_DEMAND_CONTAINERS="/var/lib/docker/volumes/docker_sites_enabled/_data/on-demand"

shopt -s nullglob
for filename in $ON_DEMAND_CONTAINERS/*.conf; do
    first_line=$(head -n 1 $filename)
    timeout=$(echo $first_line | cut -d ":" -f2)
    domain=${filename%.conf}
    domain=${domain##*/}
    #echo $domain: $timeout
    recent_logs=$(docker logs $domain.fpm --since $timeout 2>&1 | cat)

    if [ -z "$recent_logs" ]; then
        #echo "Container '$domain.fpm' has not any traffic for $timeout. Pausing container..."
        systemctl stop fpm@$domain.service
    fi
done