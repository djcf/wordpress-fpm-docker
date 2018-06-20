apps-wordpress-base
=========

A simple role to provide default variables to other roles in the `apps-wordpress-*` family. Does nothing by itself.

Role Variables Provided
=========

    docker_image: "drupal7-php7.1-fpm-alpine-mod"

Which docker image to use by default for drupal. It's based from the official docker image `drupal-php7.1-fpm-alpine` which provides drupal with php 7.1 and fpm running in alpine. We then modify it substantially using the Dockerfile in `docker/apps/drupal`.

    use_php: yes

Instructs the vhost template to write out /*.php directives using `vhost-renew/templates/php-vhost.j2`.

    phproot: /usr/src/drupal7

This path is the default installation location for drupal in alpine linux containers. Since d7 installs to /var/www/html, we have to symlink it here first. That's so that `switchboard` container can provide the correct container-agnostic path to the d7 fpm service.

    extra_nginx_configs:
      - inc/drupal.conf

You can supply a list of files which should be included but don't forget that `inc/drupal.conf` *is* a requirement of drupal sites.