This directory contains vhosts.

It is usually mapped as /etc/nginx/sites-enabled and available to the host as docker volume `docker_sites_enabled`.

vhosts included here at automatically included as *.conf files. This means you can disable one by renaming it to $domain.conf.old. Then run:

	docker exec -it switchboard nginx -s reload

You can edit any vhost in these directories freely. They will only be over-written if someone runs the ansible role renew-vhost with the 'domain' value matching the vhost's filename $domain.conf.

You can also freely add new vhosts to these directories -- just remember to keep them in the right one for convenience. After you create, remove or edit a vhost, run:

	docker exec -it switchboard nginx -s reload

nginx will not reload the new config if there is an error, and will carrying on running regardless. (NB: DO NOT RUN nginx restart or docker (stop/start) switchboard or even systemctl (stop/start) (switchboard/nginx/httpd), all of which have the same effect.)

Don't forget you can also do a config test with:

	docker exec -it switchboard nginx configtest


** Included automatically **: Yes
** By what? **: nginx.conf root directive, and ansible
** When? **: When a play is run which uses the vhost-renew role and when nginx is reloaded.
** Where-mapped?**: /etc/nginx/sites-enabled