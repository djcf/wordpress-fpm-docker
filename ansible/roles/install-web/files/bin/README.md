This directory contains a collection of bash scripts which are used to illustrate important procedural points and can be used by admins for testing.

**mem-usage.sh** is a useful one-liner for mapping memory used by a child process. It's actually not related to this sytem since docker does this automatically

**mysql** is a one-line mysql client invoker

**renew-fpm-container.sh** takes the complicated work out of removing and re-producing on-demand php-fpm containers

**renew-fpm-socket.sh** fixes systemd's communication with the on-demand docker container by removing /var/run/docker-apps/$domain and re-starting the systemd units responsible for that directory

**view-on-demand-containers.sh** simply lists on-demand containers

**waitport.sh** and **waitsock.sh** are both used to proxy traffic from systemd, which sits between nginx and php-fpm, into the php-fpm containers