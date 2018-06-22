#!/bin/bash

# Generate a one-use autologin for Wordpress

if [ "$#" -ne 2 ]; then
    echo "Imports an SQL file into a database by reading an env file"
    echo "ENV_PATH should refer to an .env file to load"
    echo ""
    echo "Useage: $0 ENV_PATH SQL_DUMP_PATH"
    exit 1
fi

if [[ $2 == *".gz"* ]]; then
	docker run \
		--env "FILE=/tmp/database.sql.gz" \
		--net=docker_sqlnet \
		--link sqldb.common.scot:sqldb.common.scot \
		--env-file $1 \
		--volume $2:/tmp/database.sql.gz:ro \
		-it \
		--rm \
		gists/mariadb \
		sh -c \
			'gunzip -c $FILE | mysql -u$DB_USER $DB_NAME'
else
	docker run \
		--env "FILE=/tmp/database.sql" \
		--net=docker_sqlnet \
		--env-file $1 \
		--link sqldb.common.scot:sqldb.common.scot \
		--volume $2:/tmp/database.sql:ro \
		-it \
		--rm gists/mariadb \
		sh -c \
			'cat $FILE | mysql -u$DB_USER $DB_NAME'
fi
