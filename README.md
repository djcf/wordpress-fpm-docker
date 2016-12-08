App Fleet
--------

Uses vagrant to initialize a composable wordpress fleet or other fleet of php fpm applications.

Uses nginx/dockergen to automate vhost creation

Also includes a set of ansible scripts to automate and manage the web apps.

Vagrant

	* Automatically installs fish, docker and docker-compose into the new system

Docker-compose

	* Docker-compose pre-builds the fpm image and wordpress images and
	* docker-compose then downloads mariadb and nginx/dockergen

The web host uses systemd's socket activation to kill off fpm processes which are not in use. To see how that works, look here: https://developer.atlassian.com/blog/2015/03/docker-systemd-socket-activation/

SOCKET ACTIVATION
-------
http://www.dest-unreach.org/socat/doc/README
http://danwalsh.livejournal.com/74421.html
https://torusware.com/blog/2015/04/optimizing-communications-between-html/

NGINX DYNAMIC CONFIG GENERATION
------
See also: https://github.com/jwilder/nginx-proxy
and https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion
Overview: http://jasonwilder.com/blog/2014/03/25/automated-nginx-reverse-proxy-for-docker/

DYNAMIC CONFIG GENERATION DNS
------
See also: https://github.com/jderusse/docker-dns-gen

SERVICES
-------

The systemd.services file contains service definitions which you can use to talk directly to the main containers. For example, one can run:

    service nginx reload

    or

    service mysql stop

And expect that these services will perform appropriately.

You can also refer to each vhost by its domain, e.g.:

	service tld.mydomain.org stop

See also this useful list of systemd commands: https://www.dynacont.net/documentation/linux/Useful_SystemD_commands/ (more detail: https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units). For more information about running docker containers as systemd processes, check here http://container-solutions.com/running-docker-containers-with-systemd/, here https://goldmann.pl/blog/2014/07/30/running-docker-containers-as-systemd-services/ and here http://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/.

Since systemd would by default talk to the docker client process and not the docker daemon, we use https://github.com/ibuildthecloud/systemd-docker to allow sane communication between docker services between the docker and systemd daemons.

TO CONFIGURE
-------

* Modify the file .env with the MySQL root password

LOCAL DEVELOPMENT (INSTALL USING VAGRANT)
-------

You can obtain an exact copy of the production environment for local testing and dev work using vagrant. First, you need vagrant (obviously) and the vagrant plugin docker-compose. Vagrant will automatically use the ansible scripts and docker-compose file to get the container assembly up and running.

    $ vagrant plugin install docker-compose
    $ vagrant up
    $ vagrant ssh

TODO
-----

	* System init should kill fpm processes when not in use
	* Ansible scripts should install new web app containers and
	* nginx/dockergen should be used instead of pure nginx
	* Ansible scripts should install and renew letsencrypt certs
	* nginx should also cache generated php files