Remove a website
================

Tested with wordpress. May work with other site types.

Operations:

1. Backup site (export SQL, zip SQL+public_html directory, download to control machine) (when backup==yes)
2. Remove $domain.conf from switchboard:/etc/nginx/sites-enabled (/var/lib/docker-volumes/docker-sites-enabled on the host)
3. Remove SSL certificates from switchboard:/etc/nginx/docker-ssl-certs
4. Load database values from environment file if $env_path supplied or $domain supplied
5. Remove database $db_name (loaded from .env file)

Usage:

Interactive usage:

	ansible-playbook -i $inventory remove-site.yml

Non-interactive:

	ansible-playbook -i $inventory remove-site.yml --extra-vars 'backup=yes remove=no domain=mydomain.org'

Archive a website
=================

Not tested yet.

Operations:

1. Run wget --archive $domaion on archive host
2. Backup site (export SQL, zip SQL+public_html directory)
3. Transfer site backup file to archive host
4. Remove SQL database
5. Renew vhost to point to archive host
6. Remove fpm container

Interactive usage:

	ansible-playbook -i $inventory archive-site.yml

Non-interactive:

	ansible-playbook -i $inventory archive-site.yml --extra-vars 'remove=no domain=mydomain.org'

Export a website
=================

Not tested yet due to control ansible 2.3+ requirement.

Operations:

0. Load SQL values from .env file (usually /var/www/$domain/.env)
1. Export SQL to a given location (usually /var/www/$domain/database.sql.gz)
2. Zip /var/www/$domain directory
3. Transfer site backup file to control machine

Interactive usage:

	ansible-playbook -i $inventory export-site.yml

Non-interactive:

	ansible-playbook -i $inventory export-site.yml --extra-vars 'domain=mydomain.org'

Other operations
================

To view documentation for operations relating to wordpress, see ./wordpress directory. To view documentation for operations relating to databases, see ./sql directory.