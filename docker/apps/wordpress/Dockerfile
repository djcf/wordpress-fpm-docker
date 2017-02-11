FROM wordpress:php7.1-fpm-alpine

RUN apk update
RUN apk add ssmtp mariadb-client
RUN curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar --info --allow-root && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp

RUN rm -rf /usr/local/etc/php-fpm.d && mkdir -p /usr/local/etc/php-fpm.d
COPY wp-cli.yml /
COPY wp-config.php /usr/src/wp-config.php
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

WORKDIR /usr/src/wordpress

VOLUME /usr/src/wordpress/wp-content
VOLUME /etc/ssmtp