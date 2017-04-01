sql-import-database
=========

This role imports a gzipped database file to a named database. It does  not create the database first.

Role Variables
--------------

Requires a `local_import_file` and a `user_site_dir` -- in addition to the usual variables relating to this task.

Example Playbook
----------------

See `ansible/plays/sql/import-database.yml`