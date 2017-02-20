#!/bin/sh

# Consume a string of n user-names (actually primary-subdomain-type IDs => mungled database user IDs)
while [ "$1" != "" ]; do
	DIR=/var/www/$1/public_html/wp-content # use this directory as a source of canonical UID "truth" from the host system
	mkdir -p $DIR # prevent errors later on
	canonical_UID=`stat -c %u "$DIR"` # get the user ID which owns that directory
	USER_NAME=`stat -c %U "$DIR"` # get the user name which owns that directory (according to the container). will either be "Xx" (defined) or unknown

	WWDGID=`getent group www-data | cut -d: -f3` # what group *should* the user have?
	# spoiler alert: the answer is 1000. the mechanism is elegent but could cause a bug if the container's www-data is set incorrectly.
	if [ "$WWDGID" != 1000 ]; then
		echo "ALERT: www-data DID NOT HAVE GID 1000"
	fi

	if id "$1" >/dev/null 2>&1; then # check if the user name exists in the container
		local_UID=`id -u $1`
		echo "User $1 exists" # it does...
		if [ "$USER_NAME" == root ]; then # check if the user which owns the directory is root (UID 0)
			echo "Changing ownership of $DIR away from root"
			chown -R $1:www-data $DIR # change the directory to match the username/id of the user
		elif [ "$local_UID" != "$canonical_UID" ]; then # the user which owns the directory is not root, but it isn't the same one which is supposed to either.
			echo "Changing user id of existing user to match remote"
			/usr/local/bin/chids.sh $1 www-data $canonical_UID $DIR # invoke external script to change the UID locally
		fi
	else # the username does not exist in the container,
		echo "Adding user $1:" # so whatever else happens we'll need to create it
		if [ "$USER_NAME" = "root" ]; then # check if the user which owns the directory is root
			adduser -SDH -G www-data -s /bin/false $1 # it was, so add a new user with any old user ID...
			echo "Changing ownership of $DIR away from root"
			chown -R $1:www-data $DIR # ... and chown the external directory to match the new username and ID
		else # a specific non-root user owns the directory, but we dont have a matching username in the container
			adduser -SDH -G www-data -u $canonical_UID -s /bin/false $1 # add a new user to the container with a specific user ID
		fi
	fi
	shift
done