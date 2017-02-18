Create a Wordpress host
==================

Operations:

1. Munge the domain inputs into a sensible format
2. If applicable, upload SSL certificates from local computer
3. Template apps-wordpress-create/templates/vhost.j2 to /var/lib/docker/volumes/docker_sites-enabled/_data/$prefix/$primary_subdomain.conf
4. Generate and save values for $db_name, $db_password, $db_user to /var/$primary_subdomain/.env
5. Create a wordpress fpm container if the website should be started on_demand OR
5. Template out a new php-pool to the php-fpm-group container if going into shared hosting and create a new user inside that container. Change ownership of wp-content files accordingly.
6. Test to see if a database exists with the values in the .env file and can be connected to then
7. Create a new database if not
8. Test to see if Wordpress has been installed to the database and
9. Install wordpress using wp CLI to the database if not

Usage:

Interactive usage:

	ansible-playbook -i $inventory create-wordpress-site.yml

Non-interactive:

	ansible-playbook -i $inventory create-wordpress-site.yml --extra-vars TODO

Non-interactive, with access to all variables:

ansible-playbook  -i $inventory \
	--extra-vars "domain=mydomain.org subdomain=mysubdomain.noflag.org.uk site_title="test" admin_email=email@address.org" \
	plays/wordpress/create-wordpress-site.yml

Import a wordpress site
==================

Untested.

Operations:

1. Munge the domain inputs into a sensible format
2. If applicable, upload SSL certificates from local computer
3. Template apps-wordpress-create/templates/vhost.j2 to /var/lib/docker/volumes/docker_sites-enabled/_data/$prefix/$primary_subdomain.conf
4. Generate and save values for $db_name, $db_password, $db_user to /var/$primary_subdomain/.env
5. Create a wordpress fpm container if the website should be started on_demand OR
5. Template out a new php-pool to the php-fpm-group container if going into shared hosting and create a new user inside that container. Change ownership of wp-content files accordingly.
6. Test to see if a database exists with the values in the .env file and can be connected to then
7. Create a new database if not
8. Import SQL dump
9. Copy wp-content files to /var/www/$domain/wp-content

Interactive usage:

	ansible-playbook -i $inventory import-wordpress-site.yml

Non-interactive usage is very similar to "Create a Wordpress Host" (see above),