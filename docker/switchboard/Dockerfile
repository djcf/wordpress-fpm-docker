FROM nginx:1.11.9-alpine

RUN addgroup -g 1000 -S www-data && adduser -u 1000 -D -S -G www-data www-data
COPY nginx.conf /etc/nginx
RUN mkdir -p /var/www/html && echo "Switchboard OK" > /var/www/html/index.html

HEALTHCHECK CMD curl --fail http://localhost || exit 1