common
=========

This role provides defaults for use by nearly all other roles. It also gathers facts used by other roles, mainly relating to the location of specific docker named volumes. Its last purpose is to provide the handlers `reload nginx` and `reload fpm`


Role variables
============

    switchboard: switchboard

This is the name of the nginx container instance which manages vhosts and SSL.

    group_fpm_container: group-wordpress.fpm

This is the name of the group fpm container

    default_cert: default

This is the root name of the default wildcard cert used by the host, stored in `/var/lib/docker/volumes/docker_ssl_certificates/_data`

    domain_host: "noflag.org.uk"

This is the homepage of the organization which manages websites on this server. It's used mainly to second-guess user input and account for discrepencies in what they entered. It also appends to `primary_subdomain` to create permanent vhost subdomains which are assumed to be more permanent than top-level domains which a user might supply.

    docker_volume_lbls:
      - "docker_sites_enabled"
      - "docker_htpasswd"
      - "docker_nginx_config"
      - "docker_nginx_config_inc"
      - "docker_vhost_config"
      - "docker_ssl_certs"
      - "docker_group_php_pools"

This is the list of named docker volumes whose absolute paths we want to provide to other roles.

    admin_email: "admin@lists.noflag.org.uk"
    install_path: /usr/local/web

This repository should be installed here so that admins may submit pull requests remotely, for manual invocations of `docker-compose` to find a docker-compose.yml file, and also because admins might choose to run ansible directly on the remote host.

    mysql_host: sqldb.{{ domain_host }}

The SQL database container hostname as it appears to a container, i.e. the host alias assigned by docker. Giving it a standard DNS may ease admin burden later if the SQLDB needed to be hosted elsewhere. `mysql_host` becomes an environment variable by way of the `container-environments` role's .env file where it is used by the `mysql_client` inside a container.

    sqldb: sqldb.{{ domain_host }} 

The sqldb container name as it appears to the host. Again, using a standard DNS is wise. There's no reason in theory that it should differ from `mysql_host`, above.

    mysql_tcp_port: 3306

Also becomes .env variable for use by mysql-client and other container applications.