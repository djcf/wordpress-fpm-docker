FROM jwilder/docker-gen

RUN mkdir -p /etc/docker-gen; rm -f /var/cache/apk/*
COPY nginx.tmpl /etc/docker-gen/templates/nginx.tmpl
COPY hardening.sh /usr/local/bin
RUN /usr/local/bin/hardening.sh
