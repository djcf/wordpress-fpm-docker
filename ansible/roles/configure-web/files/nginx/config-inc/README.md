This directory is used for generic vhost configuration which does not apply to all vhosts. For example, configuration for all wordpress vhosts, or configuration for all ssl vhosts, that all lives here.

It is ** not ** included automatically at any stage. It is included manually within a vhost declaration. All vhosts *should* include the general.conf.

** Included automatically **: No
** By what? **: Ansible will include *certain files* in some cases during vhost generation. Dockergen will/should include ssl.conf where possible.
** When? **: When a play is run which uses the vhost-renew role.
** Where-mapped?**: /etc/nginx/confg-inc