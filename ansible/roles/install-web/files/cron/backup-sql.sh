#!/bin/bash
MYSQL_IMAGE="gists/mariadb"
BACKUPS=/var/backups/sql
mkdir -p $BACKUPS

for d in /var/www/*; do
	domain=$(basename $d)
	if [ -e "$d/.env" ]; then
		docker run --env-file "$d/.env" --name $domain.backupdb --rm $MYSQL_IMAGE sh -c 'mysqldump -u$DB_USER -p$DB_PASSWORD -h$DB_HOST -p$DB_PORT $DBNAME' | gzip -9 > $BACKUPS/$domain.sql.gz
	fi
done