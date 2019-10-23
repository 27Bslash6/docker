#!/bin/bash
set -e

mkdir -p /run/php

# make terminal programs happy, eg. vim, less
echo "export TERM=xterm-256color" >> /root/.bashrc

# Remove duplicate newrelic.ini files. Solves "Module 'newrelic' already loaded" warning message
# See: https://discuss.newrelic.com/t/php-warning-module-newrelic-already-loaded-in-unknown-on-line-0/2903/21
rm -f /etc/php/${PHP_VERSION}/fpm/conf.d/newrelic.ini
rm -f /etc/php/${PHP_VERSION}/cli/conf.d/newrelic.ini


# Still necessary in case of misconfiguration in sites-enabled/
sed -i -r "s/;cgi.fix_pathinfo\s*=\s*1/cgi.fix_pathinfo=0/g" /etc/php/${PHP_VERSION}/fpm/php.ini

# Don't fork
sed -i -r "s/;daemonize = yes/daemonize = no/g" /etc/php/${PHP_VERSION}/fpm/php-fpm.conf

# Catch PHP output
sed -i -r "s/;catch_workers_output =/catch_workers_output =/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# Fix socket permissions
sed -i -r "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf

# Enable sendmail additional parameters
sed -i -r "s/;sendmail_path =/sendmail_path =/g" /etc/php/${PHP_VERSION}/fpm/php.ini

# Clear upstream data
rm /app/www/index.html
echo "<?php phpinfo(); " > /app/www/index.php

# enable Exim TLS
echo "MAIN_TLS_ENABLE = 1" >> /etc/exim4/exim4.conf.localmacros
