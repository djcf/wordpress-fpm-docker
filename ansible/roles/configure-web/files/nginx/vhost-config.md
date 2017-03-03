This directory is where per-vhost auto-includes live.

For example if a certain vhost needs extra or special directives, those directives live here. Each file has the name of the unique subdomain it refers to, e.g. for test.noflag.org.uk, the file is named test.conf. It is automatically inserted *into* test.noflag.org.uk's vhost declaration, between the server { } blocks.

** Included automatically **: Yes
** By what? **: Ansible (and dockergen, I think)
** When? **: When the vhost-renew role is run
** Where-mapped?**: /etc/nginx/vhost.d