#!/usr/bin/env bash

grep /etc/passwd

exec setuser ${APP_USER:-$DEFAULT_APP_USER} php /app/wp-cli.phar --path="/app/www" $@