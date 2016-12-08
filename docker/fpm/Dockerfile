FROM debian:jessie-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /var/lib
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
    rm -rf /var/lib/apt/lists && \
    mkdir -p /usr/share/nginx/html

COPY www.conf /etc/php5/fpm/pool.d/www.conf
COPY php-fpm.conf /etc/php5/fpm
COPY index.php /usr/share/nginx/html/index.php

VOLUME /etc/ssmtp

CMD ["/usr/sbin/php5-fpm", "--nodaemonize"]