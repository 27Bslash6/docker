FROM funkygibbon/docker-ubuntu-base

MAINTAINER Ray Walker <hello@raywalker.it>

# APT
RUN apt-get update && \
	apt-get install -y wget && \
	wget -q http://nginx.org/keys/nginx_signing.key -O- | sudo apt-key add - && \
	echo deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
	echo deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get -y install \
		nginx \
		php5-fpm \
		php5-mysql \
		php-apc \
		exim4 \
		php5-cli \
		php5-gd \
		php5-intl \
		php5-imagick \
		php5-imap \
		php5-mcrypt \
		php5-mhash \
		php5-redis \
		php5-xdebug \
		php5-recode && \
	apt-get -y remove wget && \
	apt-get clean

# Enable php modules which may not be enabled by default
RUN php5enmod mcrypt imap

# Base php configuration
RUN cp /etc/php5/fpm/php.ini /etc/php5/fpm/php.ini.dist && \
    echo "display_errors=On\nhtml_errors=On\n" >> /etc/php5/mods-available/xdebug.ini && \
	sed -i -r "s/;cgi.fix_pathinfo\s*=\s*1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini && \
	sed -i -r "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf && \
	sed -i -r "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf && \
	sed -i -r "s/;listen.mode = 0660/listen.mode = 0750/g" /etc/php5/fpm/pool.d/www.conf

# Base nginx configuration
RUN	cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.dist && \
	sed -i "s/.*conf\.d\/\*\.conf;.*/&\n    include \/etc\/nginx\/sites-enabled\/\*;/" /etc/nginx/nginx.conf && \
	echo "\ndaemon off;" >> /etc/nginx/nginx.conf

RUN echo "MAIN_TLS_ENABLE = 1" >> /etc/exim4/exim4.conf.localmacros

RUN mkdir -p /app && echo "<?php\nphpinfo();\n" > /app/index.php
