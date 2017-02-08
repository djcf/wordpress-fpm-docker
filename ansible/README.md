This directory contains the ansible plays used to configure the server. They do things like:

./configure-host:
	* Installing the LEMP container assembly
	* Installing the master DNS server

./add-vhosts:
	* Add new virtual hosts to nginx
	* Add new php process managers to docker
	* Install wordpress

To install a new wordpress host:
ansible-playbook  -i $inventory --extra-vars "domain=mydomain.org subdomain=mysubdomain.noflag.org.uk admin_email=email@address.org" add-vhosts/add-wordpress-vhost.yml

Boolean variables are ** NOT ** parsed correctly through the command-line. If you need to do pass a boolean to override a default option you must pass the entire string as JSON:

ansible-playbook -i $inventory --extra-vars "{ 'ssl_host': false, 'domain': 'mydomain.org', 'subdomain':'mysubdomain.noflag.org.uk', 'admin_email': 'admin@example.org'}" add-wordpress-vhost.yml
