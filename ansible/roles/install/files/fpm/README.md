This directory contains php pools. It is automatically mapped into the group-fpm container, to override the default pool built into the on-demand container. In this respect, it is the only thing which distinguishes the two types of php-wordpress container.

** Included automatically **: Yes
** By what? **: php.ini, in a php-fpm container
** When? **: When the fpm daemon starts, usually as a consequence of the group-fpm container being created. Files templated here by ansible when the group-fpm role is run.
** Where-mapped?**: /usr/local/etc/php-fpm/pools