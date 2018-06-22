#!/bin/bash
docker run --env-file /var/www/$1.env -i --link sqldb.common.scot:mysql --rm mysql sh -c "mysqldump $DB_NAME"