#!/usr/bin/env bash

set -e

_title "funkygibbon/wordpress-stateless"

# Set ownership to application user/group
chown -R ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www

# Overwrite the pre-installed wp-config to use env vars
cp /app/wp-config.php.dist /app/www/wp-config.php

# Generate random strings for Wordpress keys and salts if required
GEN_RANDOM='</dev/urandom tr -dc "A-Za-z0-9!#% &()*+,-./:;<=>?@^_{|}~" | head -c 64  ; echo'

if [ -z "${WP_AUTH_KEY}" ]; then
    export WP_AUTH_KEY="${!GEN_RANDOM}"
fi
#_good "WP_AUTH_KEY:         ${WP_AUTH_KEY}"

if [ -z "${WP_SECURE_AUTH_KEY}" ]; then
    export WP_SECURE_AUTH_KEY="${!GEN_RANDOM}"
fi
#_good "WP_SECURE_AUTH_KEY:  ${WP_SECURE_AUTH_KEY}"

if [ -z "${WP_LOGGED_IN_KEY}" ]; then
    export WP_LOGGED_IN_KEY="${!GEN_RANDOM}"
fi
#_good "WP_LOGGED_IN_KEY:    ${WP_LOGGED_IN_KEY}"

if [ -z "${WP_NONCE_KEY}" ]; then
    export WP_NONCE_KEY="${!GEN_RANDOM}"
fi
#_good "WP_NONCE_KEY:        ${WP_NONCE_KEY}"

if [ -z "${WP_AUTH_SALT}" ]; then
    export WP_AUTH_SALT="${!GEN_RANDOM}"
fi
#_good "WP_AUTH_SALT:        ${WP_AUTH_SALT}"

if [ -z "${WP_SECURE_AUTH_SALT}" ]; then
    export WP_SECURE_AUTH_SALT="${!GEN_RANDOM}"
fi
#_good "WP_SECURE_AUTH_SALT: ${WP_SECURE_AUTH_SALT}"

if [ -z "${WP_LOGGED_IN_SALT}" ]; then
    export WP_LOGGED_IN_SALT="${!GEN_RANDOM}"
fi
#_good "WP_LOGGED_IN_SALT:   ${WP_LOGGED_IN_SALT}"

if [ -z "${WP_NONCE_SALT}" ]; then
    export WP_NONCE_SALT="${!GEN_RANDOM}"
fi
#_good "WP_NONCE_SALT:       ${WP_NONCE_SALT}"
