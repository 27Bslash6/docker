#!/bin/bash
set -eou pipefail

mkdir -p /run/php

# Backup original information
cp "/etc/php/${PHP_VERSION}/fpm/php.ini" "/etc/php/${PHP_VERSION}/fpm/php.ini.dist"
cp "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf" "/etc/php/${PHP_VERSION}/fpm/pool.d/www.conf.dist"

# Don't fork
sed -i -r "s/;daemonize = yes/daemonize = no/g" "/etc/php/${PHP_VERSION}/fpm/php-fpm.conf"

# Clear upstream data
rm -fr "/app/source/public" || true

mkdir -p "/app/source/public"

# Create a test PHP index file if it doesn't exist
[[ -f "/app/source/public/index.php" ]] || {
  cat <<EOF >"/app/source/public/index.php"
<?php
//TEST-DATA-ONLY
phpinfo();

EOF
}
