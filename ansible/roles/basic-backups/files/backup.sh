#!/bin/bash
TODAY=`date '+%Y_%m_%d__%H_%M_%S'`;
for VOLUME in $(/usr/local/bin/list-named-volumes.sh); do
	rsync -av /var/lib/docker/volumes/$VOLUME/_data/ /var/backups/projects/latest/volumes/$VOLUME/
done
for PROJECT in $(ls /var/www); do
	. /var/www/$PROJECT/.env
	/usr/local/bin/export-sql $PROJECT | gzip -9 > /var/backups/projects/latest/sql/$DB_NAME.sql.gz
done
zip -r -9 /var/backups/projects/$TODAY.zip /var/backups/projects/latest
gsutil push --dry-run /var/backups/projects/$TODAY.zip gs://backups.common.scot/$(hostname)/

OLD_BACKUPS=$(find /var/backups/projects/ -maxdepth 1 -name "*.zip" -type f -mtime +5)
NUM_OLD_BACKUPS=$(echo $OLD_BACKUPS | wc -l)
echo "Removing $NUM_OLD_BACKUPS old backups..."
echo $OLD_BACKUPS
find $SNAPSHOTS/backups -maxdepth 1 -name "*.zip" -type f -mtime +5 -delete

echo "Finished!"