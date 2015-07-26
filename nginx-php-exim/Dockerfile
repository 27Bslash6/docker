FROM funkygibbon/nginx-pagespeed

MAINTAINER Ray Walker <hello@raywalker.it>

RUN apt-get update && \
	apt-get -y install \
		exim4 \
		php5-fpm \
		php5-mysql \
		php-apc \
		php5-cli \
		php5-curl \
		php5-gd \
		php5-intl \
		php5-imagick \
		php5-imap \
		php5-mcrypt \
		php5-mhash \
		php5-redis \
		php5-xdebug \
		php5-recode && \
	php5enmod mcrypt imap && \
	apt-get -y remove wget && \
	apt-get clean

RUN mkdir /root/bin/ && \
	echo "export PATH=/root/bin:$PATH" > /root/.bashrc

EXPOSE 443
EXPOSE 80

ENV DEFAULT_APP_ENV=production
ENV DEFAULT_CHOWN_APP_DIR=true
ENV DEFAULT_APP_ENV production
ENV DEFAULT_VIRTUAL_HOST example.com
ENV DEFAULT_TIMEZONE Australia/Sydney
ENV DEFAULT_APP_USER nginx-php
ENV DEFAULT_APP_GROUP nginx-php
ENV DEFAULT_APP_UID 1000
ENV DEFAULT_APP_GID 1000
ENV DEFAULT_UPLOAD_MAX_SIZE 30M
ENV DEFAULT_NGINX_MAX_WORKER_PROCESSES 8
ENV DEFAULT_NGINX_KEEPALIVE_TIMEOUT 30 
ENV DEFAULT_PHP_MEMORY_LIMIT 128M
ENV DEFAULT_PHP_PROCESS_MANAGER dynamic
ENV DEFAULT_PHP_MAX_CHILDREN 6
ENV DEFAULT_PHP_START_SERVERS 3
ENV DEFAULT_PHP_MIN_SPARE_SERVERS 2
ENV DEFAULT_PHP_MAX_SPARE_SERVERS 3
ENV DEFAULT_PHP_MAX_REQUESTS 500
ENV DEFAULT_EXIM_DELIVERY_MODE local
ENV DEFAULT_EXIM_MAIL_FROM example.com
ENV DEFAULT_EXIM_SMARTHOST smtp.example.org::587
ENV DEFAULT_EXIM_SMARTHOST_MAIL_USERNAME postmaster@example.com
ENV DEFAULT_EXIM_SMARTHOST_MAIL_PASSWORD password_123

COPY etc /etc
COPY root /root
COPY env.user /root/.env.user
COPY index.php /app/www/index.php

RUN chmod 750 /root/bin/* && \
	chmod 750 /etc/service/nginx/run && \
	chmod 750 /etc/service/php5/run

RUN /root/bin/init.sh

ENTRYPOINT ["/root/bin/boot.sh"]

CMD ["/sbin/my_init"]