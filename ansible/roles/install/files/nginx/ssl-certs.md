This is where SSL certificates live.

SSL certificates are always included automatically if they match a domain or unique subdomain. For example, dockergen will include a cert named example.org.crt into a container with the environment "VIRTUAL_HOST=example.org", and ansible will automatically include a cert named test.pem into a vhost named test.common.scot.

However, the LetsEncrypt process is different. Those certs live in /etc/letsencrypt/live/$domain

Wildcard certificates are handled correctly by dockergen and by ansible. "Wildcard certificates and keys should be named after the domain name with a .crt and .key extension. For example VIRTUAL_HOST=foo.bar.com would use cert name bar.com.crt and bar.com.key." -- from https://github.com/jwilder/nginx-proxy

** Included automatically **: Yes, by dockergen and Ansible when the vhost-renew role is run.
** Where-mapped?**: /etc/nginx/certs