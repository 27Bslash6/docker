#!/bin/sh
set -e

ln -s /app/bin/add_user.sh /etc/my_init.d/00_add_user.sh

mkdir -p /etc/nginx/ssl

mkdir -p /app/www

echo "<html><head>Success</head><body><p><a href="https://hub.docker.com/u/funkygibbon/">funkygibbon</a>/nginx:${NGINX_VERSION}-${OPENSSL_VERSION} - `date`</p>" > /app/www/index.html
