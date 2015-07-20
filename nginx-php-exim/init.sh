#!/bin/bash
set -e

echo "export TERM=xterm-256color" >> /root/.bashrc

# PHP-FPM

cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.dist
cp /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.dist

echo "display_errors=On\nhtml_errors=On\n" >> /etc/php5/mods-available/xdebug.ini

sed -i -r "s/;cgi.fix_pathinfo\s*=\s*1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
sed -i -r "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
sed -i -r "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/;sendmail_path =/sendmail_path =/g" /etc/php5/fpm/php.ini

# NGINX

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.dist

sed -i "s/.*conf\.d\/\*\.conf;.*/&\n    include \/etc\/nginx\/sites-enabled\/\*;/" /etc/nginx/nginx.conf

echo "daemon off;" >> /etc/nginx/nginx.conf

# EXIM

echo "MAIN_TLS_ENABLE = 1" >> /etc/exim4/exim4.conf.localmacros

source /root/env.default
source /root/env.user