To install a new WP host:

ansible-playbook -i $inventory --extra-vars "domain=mydomain.org subdomain=mysubdomain.noflag.org.uk" add-wordpress-vhost.yml

TO override a boolean variable: 
ansible-playbook -i $inventory --extra-vars "{ 'ssl_host': false, 'domain': 'mydomain.org', 'subdomain':'mysubdomain.noflag.org.uk', 'admin_email': 'admin@example.org'}" add-wordpress-vhost.yml
