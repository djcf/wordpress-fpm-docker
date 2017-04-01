apps-wordpress-create
=========

Creates a new wordpress container

Role Variables
--------------

`volumes`: The docker volumes which, by default, the new container should use.

Requirements
-----------
`apps-wordpress-base` and `container-environments`; the latter provides a .env file and exposes the location to subsequent roles as `env_path`. Any variables already defined in that .env file become facts available to ansible during the run.

Description
-------------

First, we create a directory tree spanning usually to `/var/www/$domain/public_html/wp-content`. We then use rsync to ensure that all files in our template WP installation directory (`/var/lib/wordpress` on the host) also exist in `wp-content`. We do of course need to make sure the new permissions are correct.

Then we have to create a unique SALTS file. Since the SALTS file differs from vhost to vhost but the actual wp-config.php file doesn't, the SALTS file is external in our case. wordpress.com provide us with one ready made, we just have to download it and <?php tags. **Note: there's a potential attack-vector here from guessing what the WP server will say, and future work could avoid that by generating the SALTS file locally. (Of course we need to be careful not to overwrite one which is already there.)

We also have the potential to override `wp-config.php` files per host, which this role is responsible for taking care of, generally by adjusting the `volumes` mount-points for on-demand containers. This is dependent on whether the file `wp-config.php` exists in `/var/www/$domain/public_html` or just `wp-config-inc.php`. The former will completely overwrite the default `wp-config.php`, the latter will merely be included inside it. Generally the method of inclusion is using <?php include() statements inside the default `wp-config.php` file in which case the docker volume mounts expose the files to be accessed by php. In some cases the default file itself may be overwriten by the volume mount.

A new wordpress container is created with the correct volume-mounts which is called {{ parent_container }} and is used for all subsequent docker container-based operations, including the database.

Finally, we run `wp db check` to see if a database exists with wordpress installed in it. It is the responsibility of the playbook to decide whether to use this information to create a new database and/or install wordpress.

Example playbook
---
See `ansible/plays/wordpress/create-wordpress-site.yml`