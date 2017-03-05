#!/bin/sh
FPM_POOLS="/usr/local/etc/php-fpm.d"

if [ ! -d $FPM_POOLS ]; then
	exit 0
fi

chown -R www-data:www-data /usr/src/wordpress/wp-content

POOL_COUNT=`ls -1 $FPM_POOLS | wc -l`
# First of all, count the number of php pools. If its one, we've either running
# in the group-php container but have not been initialized with a website yet
# or we're on an on-demand container which only has 1 pool. either way, we don't want to continue
if [ "$POOL_COUNT" -eq 1 ]; then
	exit 0
fi

for filename in $FPM_POOLS/*.conf; do
	user_subdomain=${filename%.conf}
    user_subdomain=${user_subdomain##*/}
    user_suffix="_user"
    user_name="$user_subdomain$user_suffix"
    if [ "$user_name" != "www_user" ]; then
		DIR=/var/www/$user_subdomain/public_html/wp-content # use this directory as a source of canonical UID "truth" from the host system
		mkdir -p $DIR # prevent errors later on
		canonical_UID=`stat -c %u "$DIR"` # get the user ID which owns that directory
		USER_NAME=`stat -c %U "$DIR"` # get the user name which owns that directory (according to the container). will either be "Xx" (defined) or unknown
		WWDGID=`getent group www-data | cut -d: -f3` # what group *should* the user have?
		# spoiler alert: the answer is 1000. the mechanism is elegent but could cause a bug if the container's www-data is set incorrectly.
		if [ "$WWDGID" != 1000 ]; then
			echo "ALERT: www-data DID NOT HAVE GID 1000"
		fi

		if id "$user_name" >/dev/null 2>&1; then # check if the user name exists in the container
			local_UID=`id -u $user_name`
			echo "Fix perms: User $user_name exists" # it does...
			if [ "$USER_NAME" == "root" ]; then # check if the user which owns the directory is root (UID 0)
				echo "Changing ownership of $DIR away from root"
				chown -R $user_name:www-data $DIR # change the directory to match the username/id of the user
			elif [ "$USER_NAME" == "www-data" ]; then # perhaps www-data owns the directory?
				echo "Creating new user and changing ownership of $DIR away from www-data"
				adduser -SDH -G www-data -s /bin/false $user_name # it was, so add a new user with any old user ID...
				chown -R $user_name:www-data $DIR # ... and chown the external directory to match the new username and ID
			elif [ "$local_UID" != "$canonical_UID" ]; then # the user which owns the directory is not root, but it isn't the same one which is supposed to either.
				echo "Changing user id of existing user to match remote"
				/usr/local/bin/chids.sh $user_name www-data $canonical_UID $DIR # invoke external script to change the UID locally
			fi
		else # the username does not exist in the container,
			echo "Adding user $user_name:" # so whatever else happens we'll need to create it
			if [ "$USER_NAME" == "root" ]; then # check if the user which owns the directory is root
				adduser -SDH -G www-data -s /bin/false $user_name # it was, so add a new user with any old user ID...
				echo "Changing ownership of $DIR away from root"
				chown -R $user_name:www-data $DIR # ... and chown the external directory to match the new username and ID
			else # a specific non-root user owns the directory, but we dont have a matching username in the container
				adduser -SDH -G www-data -u $canonical_UID -s /bin/false $user_name # add a new user to the container with a specific user ID
			fi
		fi
	fi
done