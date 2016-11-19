FROM debian:jessie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    curl \
    git \
    ssmtp \
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
RUN curl -skSL https://getcomposer.org/installer | php
COPY www.conf /etc/php5/fpm/pool.d/www.conf
RUN cd /var/lib && \
    curl -skSL http://wordpress.org/latest.zip > wordpress.zip && \
    unzip wordpress.zip && \
    rm -f wordpress.zip

VOLUME /var/lib/wordpress/wp-content
VOLUME /var/lib/wordpress/wp-config.php

EXPOSE 9005

ENTRYPOINT /usr/sbin/php5-fpm --nodaemonize
