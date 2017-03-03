This directory defines vhosts which are automatically paused by host systemctl when no traffic is detected for a while. This mechanism happens using a cron script which reads the timeout value from the first line of the vhost.

Each vhost in this directory communicates with a unique php-fpm container, named $primary_subdomain.fpm.

Traffic out of the vhost is sent to /var/docker-apps/$domain/vhost-waker.fpm.socket, where systemd listens for incoming traffic. Upon receiving incomming traffic, systemd starts the container and sends the traffic to /usr/local/bin/waitport.sock, which waits until the container is active before sending it to the newly-started fpm process.

* If you need to prevent a container from being paused by systemd, just move it out of this directory. (../container-apps is a good idea.) There's no need to reload nginx. The host cron script will not be able to find it it, and so the container will not get paused on-demand. The php container will carry on running and never be put to sleep or will be started by systemd/docker next time it receives a connection.

* If you want to prevent a website from having a unique php-fpm container, you should re-run the ansible renew-vhost play to put it into the group-fpm container instead.


The opposite of sites running in their own on-demand php-fpm container is sites which have their own php-fpm pool in the group php container. See ../php-fpm-group for more information and a list of such sites.

## More information:

https://labs.noflag.org.uk/Noflag/web-two-point-oh/src/master/docs/1.2-On-Demand-Containers.md