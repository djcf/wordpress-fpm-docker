sql-base
=========

Provides variables relating to SQL to other ansible roles.

Role Variables
--------------

    mysql_image: gists/mariadb #yobasystems/alpine-mariadb

The official maria images aren't on alpine (yet) so we use a third-party's. It has to be this one because we need it to generate a password on first-run and half of the images out there either don't support that or have had it broken by alpine's package manager.

    db_socket: /run/mysqld/mysqld.db_socket

Unix sockets are in theory more efficient so there was a plan to have local SQL communication be performed using them. At the moment however we use plain old port 3306.

    env_values:
      - db_name
      - mysql_pwd
      - db_user
      - mysql_unix_port
      - mysql_host
      - mysql_tcp_port

These variables are loaded into ansible from the `/var/www/$domain/.env` file.

    mysql_root_password_file: /etc/mysql_root_password.txt

Todo
---

The tasks relating to loading environment data should be refactored into `container-environments`.