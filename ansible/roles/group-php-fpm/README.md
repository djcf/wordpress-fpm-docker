group-php-fpm
=========

This role creates a php pool for use by the `group-php-fpm` container. It is not nessessarily used by default for wordpress sites. Its opposite is the `containers-on-demand` role, with which it conflicts.

Role Variables
--------------

    pool_type: ondemand
    pool_max_children: 6
    pool_start_servers: 2 # only used when pool_type is dynamic
    pool_min_spare_servers: 1 # only used when pool_type is dynamic
    pool_max_spare_servers: 3 # only used when pool_type is dynamic
    pool_process_idle_timeout: 10s # only used when pool_type is ondemand
    pool_name: "{{ escaped_base }}" (filesystem-friendly escaped $primary_subdomain)

Dependencies
------------
  - common
  - { role: container-environments }
  - { role: container-remove, container_name: "{{ primary_subdomain }}.fpm" }

(`container-remove` ensures that no traces of an on-demand container exist for this website, if it was in use previously)

See Also
----
https://labs.common.scot/CommonWeal/web-two-point-oh/src/master/docs/1.3-Group-FPM.md