#!/bin/sh
set -e

mkdir -p /etc/nginx/ssl

# Generate a self signed certificate
if [ ! -f /etc/nginx/ssl/default.key ] ; then
	openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/default.key -out /etc/nginx/ssl/default.crt -nodes -days 365 -subj "/C=AU/ST=Tas/L=Launceston/O=/OU=/CN=localdomain"
fi


echo -e "funkygibbon/nginx\n`date`" > /app/www/index.html
