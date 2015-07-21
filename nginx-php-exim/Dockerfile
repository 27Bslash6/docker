FROM funkygibbon/docker-ubuntu-base

MAINTAINER Ray Walker <hello@raywalker.it>

# APT
RUN apt-get update && \
	apt-get install -y wget && \
	wget -q http://nginx.org/keys/nginx_signing.key -O- | sudo apt-key add - && \
	echo deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
	echo deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y install \
		exim4 \
		nginx \
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
	apt-get clean && \
	mkdir /app

VOLUME ["/app"]

COPY etc /etc
COPY index.php /app/index.php
COPY env.* /root/

ENV ENVIRONMENT production \
	VIRTUAL_HOST example.com \
    TIMEZONE Australia/Sydney \
    APP_USER nginx_php \
    APP_GROUP nginx_php \
    APP_UID 1000 \
    APP_GID 1000 \
    UPLOAD_MAX_SIZE 30M \
    PHP_MEMORY_LIMIT 128M \
    PHP_PROCESS_MANAGER dynamic \
    PHP_MAX_CHILDREN 6 \
    PHP_START_SERVERS 3 \
    PHP_MIN_SPARE_SERVERS 2 \
    PHP_MAX_SPARE_SERVERS 3 \
    PHP_MAX_REQUESTS 500 \
    EXIM_DELIVERY_MODE local \
    EXIM_SMARTHOST_MAIL_SMARTHOST smtp.example.org::587 \
    EXIM_SMARTHOST_MAIL_FROM example.com \
    EXIM_SMARTHOST_MAIL_USERNAME postmaster@example.com \
    EXIM_SMARTHOST_MAIL_PASSWORD password_123

EXPOSE 443
EXPOSE 80

COPY init.sh /init.sh
COPY boot.sh /boot.sh

RUN chmod 750 /init.sh && \
	chmod 750 /boot.sh && \
	chmod 750 /tests.*
	chmod 750 /etc/service/nginx/run && \
	chmod 750 /etc/service/php5/run

RUN /init.sh

ENTRYPOINT /boot.sh

CMD ["/sbin/my_init"]