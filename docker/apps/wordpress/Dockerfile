FROM wordpress:php7.1-fpm-alpine

RUN apk update; apk add ssmtp
RUN curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar --info --allow-root && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp

COPY wp-cli.yml /
COPY wp-config.php /usr/src/wp-config.php
COPY php-fpm.ini /usr/local/etc/php/conf.d

WORKDIR /usr/src/wordpress

VOLUME /usr/src/wordpress/wp-content
VOLUME /etc/ssmtp