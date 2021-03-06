## What do you need to find?

### The thing I need to find is inside a docker volume

To make it **super-easy** to find what you need, most things are now stored in docker volumes. See available volumes:

    docker volume ls

See where a volume is mapped:

    docker volume inspect $volume-name

**Spoiler-alert**: It's always /var/lib/docker/volumes/$volume-name.

#### What docker volumes are available?

  - "docker_sites_enabled" -- Contains a list of vhosts, sorted by type of vhost
      + Maps to switchboard:/etc/nginx/sites-enabled
  - "docker_htpasswd" -- Convenience location for storing htpasswds
      + Maps to switchboard:/etc/nginx/htpasswd
  - "docker_nginx_config" -- Contains top-level auto-includes, such as upstream directives, container auto-genned vhosts (see `dockergen`), and the default vhost.
      + Maps to switchboard:/etc/nginx/conf.d
  - "docker_nginx_config_inc" -- Contains config includes which are not automatically included, e.g. ssl.conf
      + switchboard:/etc/nginx/config-inc
  - "docker_vhost_config" -- Contains per-vhost configuration, e.g. the contents of $domain.conf is automatically input into the right vhost when the vhost is generated by dockergen/ansible.
      + switchboard:/etc/nginx/vhost.d
  - "docker_ssl_certs" -- Contains ssl certificates except LetsEncrypt
      + switchboard:/etc/nginx/ssl
  - "docker_group_php_pools" -- Contains per-user/site php-fpm pools for the group-fpm container
      + group-fpm:/usr/local/etc/php-fpm.d

### The thing I need to find is a website

Look in /var/www/$primary_subdomain. Here you will find the .env file which populates docker containers (and databases) with per-host values, and a public_html/wp-content directory which maps to the site's wp-content directory.

#### I need to edit wp-config.php

**For on-demand containers**, most settings are defined in /var/www/$domain/.env. You can edit the values here, then restart the container:

    docker stop $domain.fpm; docker start $domain.fpm

The .env file is used by docker to populate the container's environment. Php then picks up these settings via the php pool config, and exports them to the $_ENV and $_SERVER arrays where they can be used by wp-config.php.

(If there are settings which are not able to be specified by this file, there's a good argument for including them in the .env template (`repo:/ansible/roles/container-environments/templates/container-environment.j2`), and then setting the php pools to pick up these settings (`repo:/ansible/roles/group-php-fpm/templates/php-pool.j2`). Of course this will require regeneration of any php pool which uses group-fpm.)

You can also create a file which will be included in each site's wp-config.php. To create a file which overwrites it entirely, create the new file `/var/www/$domain/wp-config.php`. When ansible is (re-) run, the file will automatically overwrite the one in the container. If you just need to include a few configuration directives, instead create `/var/www/$domain/wp-config-inc.php`. It will be included automatically by php if the site is part of the group-fpm container. If it is an on-demand site,  you will need to re-run the ansible script which will re-create the docker container with a new volume mapping for that file into the container.

**For group-fpm containers**, the .env file isn't used. Instead, variables are injected into wp-config automatically by the relevent php pool.

#### I need to edit wp core lib

**Sanity check: Why do you want to do this?**

Okay, try the following. For on-demand containers:

    docker start $domain.fpm; docker exec -it $domain.fpm ash
    cd /usr/src/wordpress

For group-fpm:

    docker exec -it group-wordpress.fpm ash
    cd /usr/src/wordpress

#### I need to edit php.ini settings or a php pool in an on-demand container

Okay, try the following. For on-demand containers, `docker start $domain.fpm; docker exec -it $domain.fpm ash` as above, for group-fpm `docker exec -it group-wordpress.fpm ash`.

Then look in `/usr/local/etc/php` and `/usr/local/etc/php-fpm.d`.

**Okay, whatever I was trying to do worked. Now I need to make it permanent.**

If the setting you are changing is:

* A global php.conf/.ini or in the pool config for an on-demand container, edit: `repo:/docker/apps/wordpress/www.conf`. This is valid for global config and pool config in on-demand containers. Then run `docker-compose up --build`
* The pool config for group-fpm containers, edit: `repo:/ansible/roles/group-php-fpm/templates/php-pool.j2`
* Wp-config.php itself, edit `repo:/docker/apps/wordpress/wp-config.php`, then run `docker-compose up --build`
* nginx.conf itself, edit: `repo:/docker/switchboard/nginx.conf` then run `docker-compose up --build`

### The file I was told to change starts with repo:, what does this mean?

`repo:` refers to this exact repository. It's canonically-mastered at https://labs.common.scot/CommonWeal/web-two-point-oh/, where you can clone it to any directory of your computer, make changes, then push back to labs. You can of course run ansible scripts from your local computer too.

If you are running a local test environment using vagrant, repo: will be located in `/vagrant`.

If you are running on a remote server, repo: will most likely be in `/usr/local/web`

If you need to run `docker-compose`, for example to rebake config into a container, make sure you are in `repo:/docker` before doing so.

### The thing I need to find is in some other type of docker container (non-php)

Per our own convention, check /var/docker-data.