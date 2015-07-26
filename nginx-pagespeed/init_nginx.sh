#!/bin/sh
set -e

echo "wtf"

mkdir -p /etc/nginx/ssl
mkdir -p /app/www

ls -al /app/www

mv /index.html /app/www

ls -al /app/www

# Generate a self signed certificate
if [ ! -f /etc/nginx/ssl/default.key ] ; then
	openssl req -x509 -newkey rsa:2048 -keyout /etc/nginx/ssl/default.key -out /etc/nginx/ssl/default.crt -nodes -days 365 -subj "/C=AU/ST=Tas/L=Launceston/O=/OU=/CN=localdomain"
fi
