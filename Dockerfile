FROM armhfbuild/debian

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    curl \
    sudo \
    git \
    ssmtp \
    wget \
    zip \
    unzip \
    php5-cli \
    php5-mysql \
    php5-intl \
    php5-curl \
    php5-fpm \
    php5-gd \
    php-pear && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists
RUN curl -Ls https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/bin/wp && \
    chmod 755 /usr/bin/wp && \
    curl -sS https://getcomposer.org/installer | php
COPY www.conf /etc/php5/fpm/pool.d/www.conf
RUN cd /var/lib && \
    wget http://wordpress.org/latest.zip && \
    unzip latest.zip && \
    rm -f /var/lib/latest.zip

VOLUME /var/lib/wordpress/wp-content
VOLUME /var/lib/wordpress/wp-config.php

EXPOSE 9005

ENTRYPOINT /usr/sbin/php5-fpm --nodaemonize
