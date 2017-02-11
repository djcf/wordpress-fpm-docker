FROM nginx:1.11.9-alpine

RUN addgroup -g 1000 -S www-data && adduser -u 1000 -D -S -G www-data www-data
COPY nginx.conf /etc/nginx