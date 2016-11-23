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
    rm -rf /var/lib/apt/lists

COPY www.conf /etc/php5/fpm/pool.d/www.conf
COPY php-fpm.conf /etc/php5/fpm

VOLUME /etc/ssmtp

EXPOSE 9005

CMD ["/usr/sbin/php5-fpm", "--nodaemonize"]
