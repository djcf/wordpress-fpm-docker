This file contains systemd's service descriptors for the webhost. They live in /etc/systemd/system/ and are automatically put there by ansible.

The mysql.service and nginx.service are used to bind an admin's service commands e.g.

	service mysql restart

to the MysQL service running in docker.

See also a list of useful systemd commands: https://www.dynacont.net/documentation/linux/Useful_SystemD_commands/ and even more detail: https://www.digitalocean.com/community/tutorials/how-to-configure-a-linux-service-to-start-automatically-after-a-crash-or-reboot-part-1-practical-examples

Each php vhost's fpm containers are also activated by service descriptor proxies in this location, configured by ansible.

For a brilliant and comprehensive overview of how on-socket activated containers works, read: https://developer.atlassian.com/blog/2015/03/docker-systemd-socket-activation/

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