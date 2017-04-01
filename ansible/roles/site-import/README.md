site-import
=========

A simple role to import a website's content.

Role Variables
------------

It requires a file in `{{ playbook_dir }}/{{ site_dump_file }}` on the local machine where it can find a zipped archive of a site such that the root directory contains a file named `database.sql.gz` and a `wp-content` directory. It moves this archive's contents to `user_site_dir`.

Example Playbook
----------------

See `ansible/plays/wordpress/import-wordpress-site.yml`