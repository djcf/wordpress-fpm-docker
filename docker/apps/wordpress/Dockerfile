ARG TAG=php7.1-fpm-alpine
ARG EDGE=FALSE
FROM wordpress:$TAG

# Add fix-user script to docker run command
#COPY chids.sh /usr/local/bin/chids.sh
#COPY create-users.sh /usr/local/bin/create-users.sh
#COPY add-users.sh /usr/local/bin/add-users.sh
#RUN sed -i 's/^exec "$@"/\/usr\/local\/bin\/create-users.sh\nexec "$@"/g' /usr/local/bin/docker-entrypoint.sh
#RUN sed -ri 's/^www-data:x:82:82:/www-data:x:1000:1000:/' /etc/passwd

RUN if $EDGE -eq "TRUE"; then cd /usr/src && wget https://wordpress.org/latest.zip; rm -rf wordpress; unzip latest.zip; fi

ADD  https://gist.githubusercontent.com/djcf/bcd2f725652f46b4786e29ffdc32495c/raw /usr/local/bin/minify.sh
COPY wp-cli.yml /
COPY wp-config.php /usr/src/wordpress/wp-config.php
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

#delgroup `getent group 33 | cut -d: -f1`
RUN apk add --update ssmtp mariadb-client fcgi && \
	curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp && chmod +x /usr/local/bin/wp && \
	rm -rf /usr/local/etc/php-fpm.d && mkdir -p /usr/local/etc/php-fpm.d && \
	deluser www-data && deluser `getent passwd 33 | cut -d: -f1`  && addgroup -g 33 -S www-data && \
	adduser -D -u 33 -s /bin/false -h /usr/src/wordpress -G www-data www-data && \ 
	chmod +x /usr/local/bin/minify.sh && /usr/local/bin/minify.sh && \
	chown -R www-data:www-data /usr/src/wordpress && chmod -R 0444 /usr/src/wordpress && \
	find /usr/src/wordpress -type d -exec chmod 755 {} +

COPY www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /usr/src/wordpress

#VOLUME /usr/src/wordpress/wp-content

# See https://easyengine.io/tutorials/php/fpm-status-page/
# And https://www.thatsgeeky.com/2012/02/directly-connecting-to-php-fpm/
# Unfortunately this writes to logs which would conflict with on-demand containers -- unless we can find a way to stop it from doing so
#HEALTHCHECK CMD \
#    SCRIPT_NAME=/ping \
#    SCRIPT_FILENAME=/ping \
#    REQUEST_METHOD=GET \
#	cgi-fcgi -bind -connect /var/run/php-fpm.sock || exit 1