FROM fpm

RUN curl -skSL https://getcomposer.org/installer | php
RUN curl -Ok https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && php wp-cli.phar --info --allow-root && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp
RUN curl -OsLk http://wordpress.org/latest.zip && \
    unzip latest.zip && \
    rm -f latest.zip

VOLUME /var/lib/wordpress/wp-content
VOLUME /var/lib/wordpress/wp-config.php
