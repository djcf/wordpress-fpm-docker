To install a new WP host:

ansible-playbook -i $inventory --extra-vars "domain=mydomain.org subdomain=mysubdomain.noflag.org.uk" add-wordpress-vhost.yml

