FROM jwilder/docker-gen

RUN mkdir -p /etc/docker-gen/templates
COPY templates/nginx.tmpl /etc/docker-gen/templates
ADD https://gist.githubusercontent.com/djcf/bcd2f725652f46b4786e29ffdc32495c/raw /usr/local/bin/minify.sh
RUN chmod +x /usr/local/bin/minify.sh && /usr/local/bin/minify.sh