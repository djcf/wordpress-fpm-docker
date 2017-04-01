site-export
=========

Exports a full site archive including content.

Dependencies
------------

`sql-dump-database` creates the database dump before the site archive is created.

Example Playbook
----------------

    # Usage: ansible-playbook --extra-vars "domain=mydomain.orgk" plays/wordpress/remove-wordpress.yml
    - hosts: all
      vars_prompt:
        - name: "primary_subdomain"
          prompt: "Enter the primary_subdomain you would like to export"
          private: no
      roles:
        - { role: site-export, when: backup != "no", dump_path: "/var/www/{{ primary_subdomain }}/database.sql.gz" }
      post_tasks:
        - name: fetch site export
          fetch:
            src: "/var/www/{{ primary_subdomain }}/site_export.zip"
            dest: "{{ primary_subdomain }}.zip"

Known issues
---
Not tested due to ansible 2.3+ dependency.