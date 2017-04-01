apps-wordpress-base
=========

A simple role to provide default variables to other roles in the `apps-wordpress-*` family. Does nothing by itself.

Role Variables Provided
=========

    docker_image: "wordpress-php7.1-fpm-alpine-mod"

Which docker image to use by default for wordpress. It's based from the official docker image `wordpress-php7.1-fpm-alpine` which provides wordpress with php 7.1 and fpm running in alpine. We then modify it substantially using the Dockerfile in `docker/apps/wordpress`.

    admin_user: admin
    site_title: "{{ primary_subdomain }}"

Defaults for Wordpress

    use_php: yes

Instructs the vhost template to write out /*.php directives using `vhost-renew/templates/php-vhost.j2`.

    phproot: /usr/src/wordpress

This path is the default installation location for wordpress in alpine linux containers

    extra_nginx_configs:
      - inc/wordpress.conf

You can supply a list of files which should be included but don't forget that `inc/wordpress.conf` *is* a requirement of wordpress sites.

    salts_file: "{{ user_site_dir }}/public_html/salts.php"

SALTS are the part of the wp-config file which manages unique identifiers for cookies and uniquely-crypted password storage.

    user_wp_content_dir: "{{ user_site_dir }}/public_html/wp-content"

This path exists on the host. If the the group-fpm container is in use, it will exist in the container as well.
