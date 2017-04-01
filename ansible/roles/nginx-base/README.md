nginx-base
---
Provides defaults for nginx vhosts but does nothing by itself

Role Variables Provided
---
    ssl_host: true
    lets_encrypt: "{{ ssl_host }}"
    default_cert: "default"
    vhost_prefix: "default"
    container_always_active: no # should be overriden by role containers-on-demand
    transport: "{{ ssl_host|ternary('https', 'http') }}"
    ssl_method: "{{ ssl_host|ternary('redirect', 'none') }}"
    primary_domain: "{{ primary_subdomain }}.{{ domain_host }}"
    domain_list: []
    use_own_certificate: false
    user_site_dir: "/var/www/{{ primary_subdomain }}"
    webroot: "{{ user_site_dir }}/public_html"
    env_path: "{{ user_site_dir }}/.env"