The playbooks in this directory refer to operations against SQL databases.

Create a database
================

Status: Initial testing complete.

To run, simply execute sql/create-database.yml. The playbook will prompt you for the name of the database, the database user, the new password, and the environment path if any.

	ansible-playbook -i $inventory sql/create-database.yml

You can also run from the command line non-interactively, like so:

	ansible-playbook -i $inventory  sql/create-database.yml  --extra-vars 'db_name=test db_user=test db_password=test env_path=""'

Or in a more complicated fashion, like this: (nessessary if passing variables which are not strings):

	ansible-playbook -i $inventory  sql/create-database.yml  --extra-vars '{"db_name":"test", "db_user":"test", "db_password":"random", "env_path":""}'

An ansible inventory must be set or supplied first. Use -i localhost, to run locally.

You can also supply the variables in a json file, for more information see the Ansible documentation.

Export a database
==================

Interactive usage:

	ansible-playbook -i $inventory export-database.yml

Non-interactive usage:

	ansible-playbook -i $inventory export-database.yml --extra-vars 'db_name=xxx'

The playbook will save the database to /tmp/database.sql.gz on the host, and then download it to $database.sql.gz.

Import a database
==================

There are two ways to do this. If you know that the database already exists, you can simply enter the database name and the name of the file to upload:

	ansible-playbook -i $inventory sql/import-database.yml

If the database does not exist, you can either create (see 'Create a Database') or run the following script instead:

	ansible-playbook -i $inventory sql/import-new-database.yml

By default, the import role will not try to find an .env file, as it doesn't know where to look for one. If you supply one when prompted or create one, the role will try to use the credentials in the env file to connect to the database instead of the root MySQL user. This is **MUCH** safer.

Environment path
------------

Sometimes, its useful to save these values into a text file known as an env file. Env files have two main uses: you can `source .env` the file in bash, after which values like $DB_PASSWORD and $DB_NAME will be available to your shell.

The other main use is by docker. When you issue a command like `docker run --environment=/some_path/.env someContainer`, the values in the .env file are automatically loaded into the containers runtime environment (which you can view using `docker exec --it $someContainer env`). This makes the values available to the application in a highly secure way. For example, it then becomes possible to create an application configuration file such that `my_application_database_password` is always set to the value `$DB_PASSWORD` in the container environment. Such a configuration file can be checked into version control and re-used in any other similar application.

.env files should only be readable by root. By default, .env files are not created unless specified.

For more information about application environment, read Chapter 3 of the 12-factor app (https://12factor.net/config)

KNOWN BUGS
----

* You cannot run this playbook from the same directory it is located in. Instead, run it from either the ../../ansible or ../plays directory (same as the readme).

* When you run noninteractively, setting the password to "random" does not automatically generate a password. Instead, you should run a command like $(date | md5sum) to create a password at runtime.
