add-sftp-user
=========

This role adds an SFTP user so that that user can access their `wp-content` files. The new user is a member of the `sftp-only` group which is only allowed to perform SFTP operations. They are also a member of `www-data`, which is how their files and file mods are interfaceable with nginx and php-fpm.

Requirements
------------

* The user's webspace must already exist, i.e. run `create-wordpress.yml` play first. `/var/www/$primary_subdomain` will be their chrooted (jailed) home directory
* System SSH daemon must be set up with an `sftp-only` group which lists the internal SFTP server as the default shell and only allowed command. `roles/install-web` performs this automatically, thus it must be run first.

Role Variables
--------------

`primary_subdomain` must be supplied as this is used to identify the user as their username.

Example Playbook
----------------

    - hosts: all
      roles:
         - { role: add-sftp-user, primary_subdomain: my_test_user }

Known Issues
----------------
This role hasn't actually been tested yet. Please test it and remove this notice.

Suspected Issues
---------------
Permissions on the user's home directory may be an issue. Pay extra attention to the group perm if you get file permission errors. I believe directories may need to be executable.

Author Information
------------------

daniellele@CommonWeal. PRs welcome.
