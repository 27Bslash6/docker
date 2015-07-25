#!/bin/bash
set -e

# make terminal programs happy, eg. vim, less
echo "export TERM=xterm-256color" >> /root/.bashrc

# PHP-FPM

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.dist
cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.dist

echo "display_errors=On\nhtml_errors=On\n" >> /etc/php5/mods-available/xdebug.ini

# Still necessary in case of misconfiguration in sites-enabled/
sed -i -r "s/;cgi.fix_pathinfo\s*=\s*1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
# Don't fork
sed -i -r "s/;daemonize = yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
# Catch PHP output
sed -i -r "s/;catch_workers_output =/catch_workers_output =/g" /etc/php5/fpm/pool.d/www.conf
# Fix socket permissions
sed -i -r "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php5/fpm/pool.d/www.conf
# Enable sendmail additional parameters
sed -i -r "s/;sendmail_path =/sendmail_path =/g" /etc/php5/fpm/php.ini


# EXIM

# enable TLS
echo "MAIN_TLS_ENABLE = 1" >> /etc/exim4/exim4.conf.localmacros
