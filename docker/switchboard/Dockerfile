FROM nginx:1.11.9-alpine

RUN apk update && apk add curl

COPY nginx.conf /etc/nginx
COPY hardening.sh /usr/local/bin

RUN addgroup -g 1000 -S www-data && adduser -u 1000 -D -S -G www-data www-data && \
	mkdir -p /var/www/html && echo "Switchboard OK" > /var/www/html/index.html && \
	/usr/local/bin/hardening.sh

WORKDIR /etc/nginx

HEALTHCHECK CMD curl --fail http://localhost || exit 1