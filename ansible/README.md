This directory contains the ansible plays used to configure the server. They do things like:

./configure-host:
	* Installing the LEMP container assembly
	* Installing the master DNS server

./add-vhosts:
	* Add new virtual hosts to nginx
	* Add new php process managers to docker
	* Install wordpress

To install a new wordpress host:
	ansible-playbook -i $inventory --extra-vars "domain=mydomain.org subdomain=mysubdomain.noflag.org.uk" configure-host/playbook.yml

