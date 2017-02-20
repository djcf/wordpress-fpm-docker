#/bin/sh
LOGIN=$1
GROUP=$2
NEWUID=$3
PATH=$4
OLDUID=`/usr/bin/id -u $LOGIN`
/usr/sbin/deluser $LOGIN
/usr/sbin/adduser -SDH -G $GROUP -u $NEWUID -s /bin/false $LOGIN
/usr/bin/find $PATH -user $OLDUID -exec chown -h $NEWUID:$GROUP {} \;