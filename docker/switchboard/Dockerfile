FROM nginx:1.11.9-alpine

RUN apk add --update curl

COPY nginx.conf /etc/nginx
ADD  https://gist.githubusercontent.com/djcf/bcd2f725652f46b4786e29ffdc32495c/raw /usr/local/bin/minify.sh

RUN deluser `getent passwd 33 | cut -d: -f1` && addgroup -g 33 -S www-data && \
	adduser -D -u 33 -s /bin/false -h /usr/src/wordpress -G www-data www-data && \ 
	mkdir -p /var/www/html && echo "Switchboard OK" > /var/www/html/index.html && \
	chmod +x /usr/local/bin/minify.sh && /usr/local/bin/minify.sh

WORKDIR /etc/nginx

HEALTHCHECK CMD curl --fail http://localhost || exit 1