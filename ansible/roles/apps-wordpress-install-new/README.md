apps-wordpress-install-new
=========

This one's nice and simple. First we check to see if the wordpress database is installed already using `wp core is-installed`, and then we install it using `wp core install` if not.

Requirements
------------

Each of these two commands is run in a separate container, but the containers operate using an environment file and volumes which are predefined from previous runs. Therefore, `container-environments`, `apps-wordpress-create` and `sql-create-database` must both be run before this role.