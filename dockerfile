ARG NGINX_BASE

FROM ${NGINX_BASE}

ADD default.conf /etc/nginx/conf.d/

RUN rm /usr/share/nginx/html/*

COPY ./dist/ /usr/share/nginx/html/
