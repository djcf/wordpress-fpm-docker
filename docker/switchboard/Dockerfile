FROM nginx:1.11.9-alpine

RUN apk update && apk add curl

COPY nginx.conf /etc/nginx
COPY hardening.sh /usr/local/bin

RUN deluser `getent passwd 33 | cut -d: -f1` && addgroup -g 33 -S www-data && \
	adduser -D -u 33 -s /bin/false -h /usr/src/wordpress -G www-data www-data && \ 
	mkdir -p /var/www/html && echo "Switchboard OK" > /var/www/html/index.html && \
	/usr/local/bin/hardening.sh

WORKDIR /etc/nginx

HEALTHCHECK CMD curl --fail http://localhost || exit 1