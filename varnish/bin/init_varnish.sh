#!/bin/sh
set -e

cp -R /app/etc/* /etc

chmod +x /etc/service/*/run
