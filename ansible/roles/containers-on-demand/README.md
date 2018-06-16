containers-on-demand
=========

This role doesn't actually perform any actions relating to containers, it simply sets up a good environment for containers to be run in. This includes remove all traces which related to the group-fpm container if that was being used to serve the website previously. It also gathers and sets facts which relate to on-demand containers for use by other ansible roles.

It's counterpart is `group-php-fpm`, with which it conflicts.

Role variables
===

    container_sleeps_after: 20m
    container_always_active: false
    state: "{{ container_always_active|ternary('present', 'started') }}"
    socket_name: "{{ primary_subdomain }}/vhost.fpm-waker" # e.g. /var/run/ docker-apps/mydomain.org/fpm-waker.sock

See also
----
https://labs.common.scot/CommonWeal/web-two-point-oh/src/master/docs/1.2-On-Demand-Containers.md