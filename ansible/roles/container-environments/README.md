container-environments
=========

Creates or loads a .env file to be used by container environments.

Role Variables
--------------
These role variables are used populate the .env file:

    DB_USER={{ db_user }}
    MYSQL_HOST={{ mysql_host }}
    MYSQL_TCP_PORT={{ mysql_tcp_port }}
    DB_NAME={{ db_name }}
    MYSQL_PWD={{ mysql_pwd }}
    PRIMARY_SUBDOMAIN={{ primary_subdomain }}
    ENVIRONMENT=live
    WEBROOT={{ webroot }}
    HTTP_USER_AGENT_HTTPS={{ ssl_host | ternary("ON", "OFF") }}
    WP_DEBUG=false
    CONTAINER_TYPE={{ group_fpm | ternary("group_fpm", "on_demand")}}
    {% if wp_prefix is defined %}
    WP_PREFIX={{ wp_prefix }}_
    {% endif %}
    {% if primary_domain is defined %}
    HTTP_HOST={{ primary_domain }}

If `env_path` is not defined, the `env_path` is assumed to be `/var/www/$primary_subdomain/.env`

If the destination defined by `env_path` does not exist, random values are used for mysql_password and the db_user and db_name are taken from the `primary_subdomain`.