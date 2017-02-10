FROM wordpress:php7.1-fpm-alpine

RUN apk add ssmtp
RUN curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar --info --allow-root && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp
COPY wp-cli.yml /
COPY wp-config.php /var/lib/wordpress/wp-config.php

WORKDIR /var/lib/wordpress

VOLUME /var/lib/wordpress/wp-content
VOLUME /etc/ssmtp