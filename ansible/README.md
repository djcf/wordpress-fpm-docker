This directory contains the ansible plays used to configure the server. They are grouped into plays within the ./plays directory, but you can run them from here. For example:

./plays/sql/create-database.yml:
	* Create a new database

./plays/wordpress/create-wordpress-site.yml:
	* Add new virtual hosts to nginx
	* Add new php process managers to docker
	* Install wordpress

For complete documentation, browse to each directory's individual README.md file.

The actual logic for these tasks is contained within ansible roles, in the roles directory.

Most roles have extremely-configurable settings, with sane defaults. All options and their defaults are included in var_files, which you can edit before running the play.

## INSTALLATION

If you are running against a newly-provisioned server, you need to run plays/system/install-web.yml and plays/system/configure-web.yml. These in turn have some requirements in ansible-galaxy, which you must install first. Run the following commands:

	ansible-galaxy install -r requirements.yml
	ansible-playbook -i $inventory plays/system/install-web.yml
	ansible-playbook -i $inventory plays/system/configure-web.yml

## USAGE EXAMPLES

You must use these plays with a valid inventory. I usually set the inventory to the $inventory variable, for example "set inventory (pwd)/hosts/local" will run against the local host, or ../.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory to run against a vagrant virtual machine.

To install a new wordpress host:

	ansible-playbook  -i $inventory plays/wordpress/create-wordpress-site.yml

The InstallShield(tm) Wizard will guide you through the rest of the setup process but if you wanted to run the command in batch mode, you can supply the arguments directly:

	ansible-playbook  -i $inventory \
		--extra-vars "domain=mydomain.org subdomain=mysubdomain.noflag.org.uk site_title="test" admin_email=email@address.org" \
		plays/wordpress/create-wordpress-site.yml

The Wizard assumes most sensible defaults, but you can turn any option off from the command-line. However,boolean variables are ** NOT ** parsed correctly through the command-line. If you need to do pass a boolean to override a default option you must pass the entire string as JSON.

For example, to disable SSL on the new host, you need to run:

	ansible-playbook -i $inventory \
 		--extra-vars "{ 'use_ssl': false, 'domain': 'mydomain.org', 'primary_subdomain': 'mysubdomain.noflag.org.uk', 'site_title': 'test', 'admin_email': 'admin@example.org'}" \
 		plays/wordpress/create-wordpress-site.yml

For complete documentation, browse each play's directory.