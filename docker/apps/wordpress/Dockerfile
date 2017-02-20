FROM wordpress:php7.1-fpm-alpine

RUN apk update
RUN apk add ssmtp mariadb-client
RUN curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar --info --allow-root && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp

RUN rm -rf /usr/local/etc/php-fpm.d && mkdir -p /usr/local/etc/php-fpm.d

COPY chids.sh /usr/local/bin/chids.sh
COPY create-users.sh /usr/local/bin/create-users.sh
# Add fix-user script to docker run command
RUN sed -i 's/^exec "$@"/\/usr\/local\/bin\/create-users.sh\nexec "$@"/g' /usr/local/bin/docker-entrypoint.sh
COPY add-users.sh /usr/local/bin/add-users.sh
#RUN /usr/local/bin/chids.sh www-data 1000 /

RUN deluser www-data && addgroup -g 1000 -S www-data && adduser -u 1000 -D -S -G www-data www-data
#RUN sed -ri 's/^www-data:x:82:82:/www-data:x:1000:1000:/' /etc/passwd

COPY wp-cli.yml /
COPY wp-config.php /usr/src/wordpress/wp-config.php
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /usr/src/wordpress

VOLUME /usr/src/wordpress/wp-content
VOLUME /etc/ssmtp