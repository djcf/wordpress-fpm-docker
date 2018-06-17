apps-wordpress-create
=========

Creates a new wordpress container

Role Variables
--------------

`volumes`: The docker volumes which, by default, the new container should use.

Requirements
-----------
`apps-drupal-base` and `container-environments`; the latter provides a .env file and exposes the location to subsequent roles as `env_path`. Any variables already defined in that .env file become facts available to ansible during the run.
