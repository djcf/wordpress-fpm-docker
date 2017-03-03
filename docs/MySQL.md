== How to use MySQL Container ==

Actually, the bundled container is MariaDB, so that is what we will refer to it as from now on. It runs in a container named sqldb.noflag.org.uk, the principle being that it could be easily removed from this host and placed into its own server in the future, without having to change any/much config. Naming containers after domains they serve or organizations following a similar convention to package or library names in e.g. Java is in any case good practice.

=== Get a root sql cli ===

    docker exec -it sqldb.noflag.org.uk mysql

Or:

    docker run -e "MYSQL_PWD=$PASSWORD" --net docker_sqlnet -it --rm gists/mariadb mysql -uroot -hsqldb.noflag.org.uk

=== Import an SQL database ===

This is actually quite easy. First we create a new container where we will run the mysql client which has the correct file/directory mapped into it. Assuming the SQL file is named database.sql, set $DB_NAME to an existing database, then run:

    docker run -it --rm \
        -e "MYSQL_PWD=$PASSWORD" \
        --net docker_sqlnet \
        -v $(pwd):/tmp
        gists/mariadb \
        sh -c '\
            cat /tmp/database.sql | mysql -uroot -hsqldb.noflag.org.uk $DB_NAME'

Likewise, if the database is gunziped, run that first:

    docker run -it --rm \
        -e "MYSQL_PWD=$PASSWORD" \
        --net docker_sqlnet \
        -v $(pwd):/tmp
        gists/mariadb \
        sh -c '\
            gunzip -c /tmp/database.sql.gz | mysql -uroot -hsqldb.noflag.org.uk $DB_NAME'

Of course, an ansible role exists to do this for you -- check https://labs.noflag.org.uk/Noflag/web-two-point-oh/src/master/ansible/plays/sql

=== Export an SQL database ===

Similar to above, only this time run mysqldump. Data will flow through the docker terminals into stdout, where you pipe it to a file or gzip it first. E.g.:

    docker exec -it sqldb.noflag.org.uk sh -c 'mysqldump $database_name' | gzip > database.sql.gz

=== See also ===

Ansible plays for importing and exporting whole sites: https://labs.noflag.org.uk/Noflag/web-two-point-oh/src/master/ansible/plays

== Troubleshooting ==

=== I need to edit my.cnf MySQL config ===

Ansible intelligently (?) chooses a sensible config when setting up the server initially, you can edit it in repo:/ansible/roles/configure-web/templates/mysql. (Note: this overrides the default baked into the image by docker in repo:/docker/sqldb/my.cnf.) To view/edit the current values, look inside the container:

    docker exec -it sqldb.noflag.org.uk ash
    cd /etc/mysql