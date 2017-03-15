#!/usr/bin/env bash

exec setuser $APP_USER php /app/wp-cli.phar --path="/app/www" $@