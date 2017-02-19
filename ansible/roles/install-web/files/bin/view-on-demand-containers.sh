#!/bin/bash
ON_DEMAND_CONTAINERS="/var/lib/docker/volumes/docker_sites_enabled/_data/on-demand"

shopt -s nullglob
for filename in $ON_DEMAND_CONTAINERS/*.conf; do
    first_line=$(head -n 1 $filename)
    timeout=$(echo $first_line | cut -d ":" -f2)
    domain=${filename%.conf}
    domain=${domain##*/}
    echo $domain.fpm: $timeout
    recent_logs=$(docker logs $domain.fpm --since $timeout 2>&1 | cat)

    if [ -z "$recent_logs" ]; then
        echo "Container '$domain.fpm' has not any traffic for $timeout."
    fi
done