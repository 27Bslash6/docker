#!/usr/bin/env bash

exec setuser ${APP_USER:-$DEFAULT_APP_USER} php /app/wp-cli.phar --path="/app/source/public" $@