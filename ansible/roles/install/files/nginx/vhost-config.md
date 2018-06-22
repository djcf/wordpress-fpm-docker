This directory is where per-vhost auto-includes live.

For example if a certain vhost needs extra or special directives, those directives live here. Each file has the name of the unique subdomain it refers to, e.g. for test.common.scot, the file is named test.conf. It is automatically inserted *into* test.common.scot's vhost declaration, between the server { } blocks.

**Q: How do I** ... renew a vhost making use of the contents of a file I just created in this directory?

**A: Run the ansible play** `repo:ansible/plays/renew-vhost.yml`

## Known bugs
* This path of this directory is inconsistently referred to in the docs.
* Files in this directory must be named $domain.conf to be auto-included by ansible and just $domain to be auto-included by dockergen.


** Included automatically **: Yes
** By what? **: Ansible (and dockergen, I think)
** When? **: When the vhost-renew role is run
** Where-mapped?**: /etc/nginx/vhost.d