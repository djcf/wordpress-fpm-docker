Renew a vhost
===============

This process is designed for when you already have a php-container environment set up but you need to renew the vhost which serves the site. For example, if you are adding a new top-level domain (`example.org`) to an existing website (`example.noflag.org.uk`) or removing one, or adding an SSL certificate, etc.

Operations: 

1. Figure out what the user meant by the domains they gave
2. Renew the vhost

Note: By default, this play assumes you're renewing a _php vhost_. If this is not the case, you should ensure use_php is set to false by editing the play, or supplying `--extra-vars="{ use_php: false }"` at runtime.

Usage:

Interactive usage:

    ansible-playbook -i $inventory renew-vhost.yml

Non-interactive:

    ansible-playbook -i $inventory renew-vhost.yml --extra-vars '{ use_php: false, domain: "mydomain.org" }'

Create a static site
================

Very similar to above. 

Operations: 

1. Figure out what the user meant by the domains they gave
2. Renew the vhost. (By default, all vhosts are static sites unless use_php is enabled or they are proxied from somewhere else.)

Usage:

Interactive usage:

    ansible-playbook -i $inventory renew-vhost.yml

Non-interactive:

    ansible-playbook -i $inventory renew-vhost.yml --extra-vars 'domain=mydomain.org'

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

Add a user to SFTP
=================
This play allows a user to connect to the host using SFTP. They cannot connect using FTP or SCP but they may use an SSH keyfile though this file must be manually added to the server by the admin. A password will also be generated for the user and stored in a text file locally (be careful not to check it into version control) where it should be immediately removed by the admin when it is no longer required.

All sftp-only users are directed to the internal sftp server upon login; it is not possible for them to run shell commands. They are chrooted into a jailed /var/www/$user directory upon login. All sftp-only users are also members of the www-data group, which is what allows them to read and write to their user files.

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