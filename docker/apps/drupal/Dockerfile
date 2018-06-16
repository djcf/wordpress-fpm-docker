FROM drupal:7-fpm-alpine
ADD  https://gist.githubusercontent.com/djcf/bcd2f725652f46b4786e29ffdc32495c/raw /usr/local/bin/minify.sh

#delgroup `getent group 33 | cut -d: -f1`
RUN apk add --update ssmtp mariadb-client fcgi && \
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php composer-setup.php && \
	php -r "unlink('composer-setup.php');" && \
	php composer.phar global require drush/drush:7.* && \
	rm -rf /usr/local/etc/php-fpm.d && mkdir -p /usr/local/etc/php-fpm.d && \
	deluser www-data && deluser `getent passwd 33 | cut -d: -f1`  && addgroup -g 33 -S www-data && \
	adduser -D -u 33 -s /bin/false -h /usr/src/drupal -G www-data www-data && \ 
	chmod +x /usr/local/bin/minify.sh && sync && /usr/local/bin/minify.sh && \
	chown -R www-data:www-data /usr/src/drupal && chmod -R 0444 /usr/src/drupal && \
	find /usr/src/drupal -type d -exec chmod 755 {} + && \
	ulimit -c 0

COPY www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /usr/src/drupal

# See https://easyengine.io/tutorials/php/fpm-status-page/
# And https://www.thatsgeeky.com/2012/02/directly-connecting-to-php-fpm/
# Unfortunately this writes to logs which would conflict with on-demand containers -- unless we can find a way to stop it from doing so
HEALTHCHECK CMD \
    SCRIPT_NAME=/ping \
    SCRIPT_FILENAME=/ping \
    REQUEST_METHOD=GET \
	cgi-fcgi -bind -connect /var/run/php-fpm.sock || exit 1