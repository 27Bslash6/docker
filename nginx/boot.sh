#!/bin/bash
set -e

if [ ! -f /etc/nginx/ssl/dhparam.pem ] ; then
	echo " * nginx:  generating /etc/nginx/ssl/dhparam.pem ..."
	mkdir -p /etc/nginx/ssl
	openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048
fi

echo -e "\nDone\n$(date)\n"

if [[ "$1" = "/sbin/my_init" ]] ; then
	exec /sbin/my_init 
else
	echo "$ /bin/sh -c $1"
	exec /bin/sh -c $1
fi