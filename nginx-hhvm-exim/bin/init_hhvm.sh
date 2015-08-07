#!/bin/bash
set -e

cp -R /app/etc/* /etc

chmod 750 /etc/service/*/run

# Make terminal programs happy, eg. vim, less
echo "export TERM=xterm-256color" >> /root/.bashrc

# HHVM

# Fix for missing ini parameters
# https://github.com/facebook/hhvm/issues/4993
echo "hhvm.enable_zend_ini_compat=false" >> /etc/hhvm/server.ini

# Trying to get error messages to show properly
# Still won't show Magento errors though
echo "hhvm.server.implicit_flush = true" >> /etc/hhvm/server.ini
echo "hhvm.error_handling.call_user_handler_on_fatals = true" >> /etc/hhvm/server.ini

# Disable xdebug by default
echo "xdebug.enable = 0" >> /etc/hhvm/php.ini

# Limits
echo "memory_limit = ${DEFAULT_PHP_MEMORY_LIMIT}" >> /etc/hhvm/php.ini
echo "upload_max_filesize = ${DEFAULT_UPLOAD_MAX_SIZE}" >> /etc/hhvm/php.ini
echo "post_max_size = ${DEFAULT_UPLOAD_MAX_SIZE}" >> /etc/hhvm/php.ini

# Probably not safe for production
echo "display_errors = 1" >> /etc/hhvm/php.ini
echo "html_errors = 1" >> /etc/hhvm/php.ini

# # Fix socket permissions
# sed -i -r "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php5/fpm/pool.d/www.conf

# # Enable sendmail additional parameters
# sed -i -r "s/;sendmail_path =/sendmail_path =/g" /etc/php5/fpm/php.ini

rm /app/www/index.html
echo "<?php phpinfo(); " > /app/www/index.php

# EXIM

# enable TLS
echo "MAIN_TLS_ENABLE = 1" >> /etc/exim4/exim4.conf.localmacros
