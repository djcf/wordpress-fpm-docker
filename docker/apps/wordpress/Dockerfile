FROM wordpress:php7.1-fpm-alpine

RUN apk update && apk add ssmtp mariadb-client fcgi

COPY chids.sh /usr/local/bin/chids.sh
COPY create-users.sh /usr/local/bin/create-users.sh
# Add fix-user script to docker run command
COPY add-users.sh /usr/local/bin/add-users.sh

#RUN sed -ri 's/^www-data:x:82:82:/www-data:x:1000:1000:/' /etc/passwd

COPY hardening.sh /usr/local/bin
COPY wp-cli.yml /
COPY wp-config.php /usr/src/wordpress/wp-config.php
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

RUN curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar --info --allow-root && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp && \
	rm -rf /usr/local/etc/php-fpm.d && mkdir -p /usr/local/etc/php-fpm.d && \
	sed -i 's/^exec "$@"/\/usr\/local\/bin\/create-users.sh\nexec "$@"/g' /usr/local/bin/docker-entrypoint.sh && \
	deluser www-data && addgroup -g 1000 -S www-data && adduser -u 1000 -D -S -G www-data www-data && \
	/usr/local/bin/hardening.sh

COPY www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /usr/src/wordpress

VOLUME /usr/src/wordpress/wp-content
VOLUME /etc/ssmtp

# See https://easyengine.io/tutorials/php/fpm-status-page/
# And https://www.thatsgeeky.com/2012/02/directly-connecting-to-php-fpm/
# Unfortunately this writes to logs which would conflict with on-demand containers -- unless we can find a way to stop it from doing so
#HEALTHCHECK CMD \
#    SCRIPT_NAME=/ping \
#    SCRIPT_FILENAME=/ping \
#    REQUEST_METHOD=GET \
#	cgi-fcgi -bind -connect /var/run/php-fpm.sock || exit 1