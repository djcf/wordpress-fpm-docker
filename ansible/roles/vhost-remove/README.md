vhost-remove
=========

A simple role to remove relevent config files and vhost data from the host.

Example playbook
===

    # Usage: ansible-playbook --extra-vars "domain=mydomain.orgk" plays/wordpress/remove-wordpress.yml
    - hosts: all
      become: true
      roles:
        - { role: site-export, when: backup != "no", dump_path: "/var/www/{{ primary_subdomain }}/database.sql.gz" }
        - vhost-remove
        - sql-remove-database
        - { role: container-remove, container_name: "{{ primary_subdomain }}.fpm" }
      post_tasks:
        - name: fetch site export
          fetch:
            src: "/var/www/{{ primary_subdomain }}/site_export.zip"
            dest: "{{ primary_subdomain }}.zip"
          when: backup != "no"

        - name: Remove all web content from host
          file:
            state: absent
            path: "/var/www/{{ primary_subdomain }}"
          when: remove != "no"