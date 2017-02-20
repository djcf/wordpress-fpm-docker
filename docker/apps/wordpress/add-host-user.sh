#!/bin/bash

if [ "$#" != 2 ]; then
	echo "Creates a login-less user on the host with an ID which matches that of a container user"
	echo "Uses /var/www/username/public_html/wp-content as a source of 'canonical truth'"
	echo "Counterpart of add-users.sh script which adds a user to a container which matches an ID found on a host-mapped patch"
	echo "There generaly isn't any need to do this, but it could be useful if that user needs to login in directly for example through SSH into a jailshell"
	echo "Untested. Demonstration of principles only."
	echo "Probably better to do this with ansible when its needed anyway."
	echo "Usage: $0 username"
	exit 1
fi

DIR=/var/www/$1/public_html/wp-content # use this directory as a source of canonical UID "truth" from the host system
mkdir -p $DIR # prevent errors later on

canonical_UID=`stat -c %u "$DIR"` # get the user ID which owns that directory
USER_NAME=`stat -c %U "$DIR"` # get the user name which owns that directory (according to the host). will either be "Xx" (defined) or unknown

if id "$1" >/dev/null 2>&1; then # check if the user name exists on the host
	local_UID=`id -u $1`
	echo "User $1 exists" # it does...
	if [ "$USER_NAME" == root ]; then # check if the user which owns the directory is root (UID 0)
		echo "Changing ownership of $DIR away from root"
		chown -R $1:www-data $DIR # change the directory to match the username/id of the user
		echo "You should now run /usr/local/bin/add-users.sh inside the container"
		echo "That script will add a user with an ID which matches the one on the host"
	elif [ "$local_UID" != "$canonical_UID" ]; then # the user which owns the directory is not root, but it isn't the same one which is supposed to either.
		echo "Changing user id of existing user to match remote"
		/usr/local/bin/chids.sh $1 www-data $canonical_UID $DIR # invoke external script to change the UID locally
	fi
else # the username does not exist on the host,
	echo "Adding user $1:" # so whatever else happens we'll need to create it
	if [ "$USER_NAME" = "root" ]; then # check if the user which owns the directory is root
		adduser -SDH -G www-data -s /bin/false $1 # it was, so add a new user with any old user ID...
		echo "Changing ownership of $DIR away from root"
		chown -R $1:www-data $DIR # ... and chown the external directory to match the new username and ID
	else # a specific non-root user owns the directory, but we dont have a matching username on the host
		adduser -SDH -G www-data -u $canonical_UID -s /bin/false $1 # add a new user to the host with a specific user ID
	fi
fi
