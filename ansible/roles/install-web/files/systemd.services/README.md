This file contains systemd's service descriptors for the webhost. They live in /etc/systemd/system/ and are automatically put there by ansible.

The mysql.service and nginx.service are used to bind an admin's service commands e.g.

	service mysql restart

to the MysQL service running in docker.

See also a list of useful systemd commands: https://www.dynacont.net/documentation/linux/Useful_SystemD_commands/ and even more detail: https://www.digitalocean.com/community/tutorials/how-to-configure-a-linux-service-to-start-automatically-after-a-crash-or-reboot-part-1-practical-examples.  For more information about running docker containers as systemd processes, check here http://container-solutions.com/running-docker-containers-with-systemd/, here https://goldmann.pl/blog/2014/07/30/running-docker-containers-as-systemd-services/

Each php vhost's fpm containers are also activated by service descriptor proxies in this location, configured by ansible. See ../ansible for those playbooks.

What is a service descriptor proxy?

Normally, we would have n number of php daemons per user, i.e. per website. For a server with 50 virtual hosts we would have 50 php daemons active, even if their websites were not in use. Since each php daemon is encapsulated in a docker container, we can use systemd to enable the php daemon's container when a vhost is activated and disable it after some number of seconds. Systemd therefore opens the sock on php/fpm's behalf prior to php/fpm being run. Since the semantics for accepting an open socket vs. opening a socket are subtly different, we need a systemd module (actually a proxy) which handles the open socket it is passed by systemd. The proxy then wakes the php/fpm container allowing to create its own new socket, and pauses the container after an amount of time.

Although this module functions as a proxy, it is conceptually easier to think of it like an alarm clock or waker for the container than a proxy. That is why each vhost's service unit proxies are known as "$vhost.waker.service" and "$vhost.waker.socket".

For a brilliant and comprehensive overview of how on-socket activated containers works, read: https://developer.atlassian.com/blog/2015/03/docker-systemd-socket-activation/

Manual page on container wakers: http://manpages.ubuntu.com/manpages/xenial/man8/systemd-socket-proxyd.8.html

Note: The service definitions in this directory are not used as runtime but are coppied in by ansible at buildtime. As a result, editing these files has no effect. Their live counterparts are in /etc/systemd/system/multi-user.targets.wants.

See also
http://0pointer.de/blog/projects/socket-activation.html socket activation
http://0pointer.de/blog/projects/socket-activated-containers.html
http://www.dsm.fordham.edu/cgi-bin/man-cgi.pl?topic=systemd-socket-proxyd&ampsect=8
http://0pointer.de/blog/projects/security.html

Implementation plan
* Use nginx to communicate with a single fpm instance by socket
* Use systemd to activate fpm on socket activation
* Use nginx to differentiate vhosts with different fpm sockets
* Change nginx to dockergen
* Write ansible scripts for importing and creating webapps
* Write ansible scripts for managing their ssl certs
* Use dockergen to manage dns