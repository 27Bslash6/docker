#!/bin/bash
set -e

cp -R /app/etc/* /etc

chmod 750 /etc/service/*/run

mkdir -p /run/php

# make terminal programs happy, eg. vim, less
echo "export TERM=xterm-256color" >> /root/.bashrc

# PHP-FPM
sed -i -r "s/fastcgi_pass unix:.*;/fastcgi_pass unix:\/run\/php\/php${PHP_VERSION}-fpm\.sock;/g" /etc/nginx/sites-enabled/default.conf
sed -i -r "s/fastcgi_pass unix:.*;/fastcgi_pass unix:\/run\/php\/php${PHP_VERSION}-fpm\.sock;/g" /etc/nginx/sites-enabled/default-ssl.conf

# Backup original information
cp /etc/php/${PHP_VERSION}/fpm/php.ini /etc/php/${PHP_VERSION}/fpm/php.ini.dist
cp /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf.dist

mkdir -p /app/xdebug

echo "display_errors=On" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "html_errors=On" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.default_enable=0"  >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.remote_enable=0"  >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.remote_autostart=0"  >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.remote_handler=dbgp"  >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.ide_key=default_ide_key"  >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.remote_host=172.17.42.1" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.remote_port=9000" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.profiler_enable=0" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.profiler_enable_trigger=0" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.profiler_output_dir=/app/xdebug" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
echo "xdebug.var_display_max_children=256" >> /etc/php/${PHP_VERSION}/mods-available/xdebug.ini

# Newrelic
sed -i -r "s/;newrelic.enabled =/newrelic.enabled =/g" /etc/php/${PHP_VERSION}/mods-available/newrelic.ini

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
