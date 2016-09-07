FROM fuww/nginx-pagespeed

MAINTAINER Joost van der Laan <joost@fashionunited.com>

RUN apt-get update && \
	apt-get -y --no-install-recommends install \
		exim4 \
		php7.0-fpm \
		php7.0-mysql \
		php7.0-sqlite3 \
		php7.0-cli \
		php7.0-curl \
		php7.0-gd \
		php7.0-intl \
		php7.0-imap \
		php7.0-mcrypt \
		php7.0-xml \
		php7.0-mbstring \
		php-pear \
		php7.0-pspell \
		php7.0-tidy \
		php7.0-xmlrpc \
		php7.0-xsl \
		php7.0-recode && \
		phpenmod -v  mcrypt imap && \
	apt-get clean

# TODO
# phpenmod mcrypt imap && \ >>> php7enmod does not exist, must do this manual
# php7.0-hash \ # php-mhash \
# 		php-apc \ not sure we need this anymore, better use opcache
# 				php7.0-redis \
  #       php7.0-memcached \
  #       php7.0-memcache \
		# php7.0-xdebug \//
		# 		php7.0-imagick \

RUN mkdir /root/bin/ && \
	echo "export PATH=/root/bin:$PATH" > /root/.bashrc

RUN apt-get -yqq install python-setuptools
RUN easy_install pip
RUN mkdir -p /opt/newrelic
WORKDIR /opt/newrelic
RUN wget -r -nd --no-parent -Alinux.tar.gz \
    http://download.newrelic.com/php_agent/release/ >/dev/null 2>&1 \
    && tar -xzf newrelic-php*.tar.gz --strip=1

ENV NR_INSTALL_SILENT 1
ENV NR_INSTALL_KEY **ChangeMe**
ENV NR_APP_NAME "Default App Name"

RUN mkdir -p /var/log/newrelic
RUN mkdir -p /var/run/newrelic



EXPOSE 443
EXPOSE 80

ENV DEFAULT_ADMIN_EMAIL nobody@example.com
ENV DEFAULT_APP_ENV production
ENV DEFAULT_CHOWN_APP_DIR true
ENV DEFAULT_VIRTUAL_HOST example.com
ENV DEFAULT_APP_HOSTNAME example.com
ENV DEFAULT_APP_USER app
ENV DEFAULT_APP_GROUP app
ENV DEFAULT_APP_UID 1000
ENV DEFAULT_APP_GID 1000
ENV DEFAULT_UPLOAD_MAX_SIZE 30M
ENV DEFAULT_NGINX_MAX_WORKER_PROCESSES 8
ENV DEFAULT_NGINX_KEEPALIVE_TIMEOUT 30 
ENV DEFAULT_PHP_MEMORY_LIMIT 128M
ENV DEFAULT_PHP_MAX_EXECUTION_TIME 300
ENV DEFAULT_PHP_MAX_INPUT_VARS 2000
ENV DEFAULT_PHP_PROCESS_MANAGER dynamic
ENV DEFAULT_PHP_MAX_CHILDREN 6
ENV DEFAULT_PHP_START_SERVERS 3
ENV DEFAULT_PHP_MIN_SPARE_SERVERS 2
ENV DEFAULT_PHP_MAX_SPARE_SERVERS 3
ENV DEFAULT_PHP_MAX_REQUESTS 500
ENV DEFAULT_PHP_DISABLE_FUNCTIONS false
ENV DEFAULT_PHP_XDEBUG_REMOTE_HOST 172.17.42.1
ENV DEFAULT_PHP_XDEBUG_REMOTE_PORT 9000
ENV DEFAULT_PHP_XDEBUG_IDE_KEY default_ide_key
ENV DEFAULT_EXIM_DELIVERY_MODE local
ENV DEFAULT_EXIM_MAIL_FROM example.com
ENV DEFAULT_EXIM_SMARTHOST smtp.example.org::587
ENV DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME postmaster@example.com
ENV DEFAULT_EXIM_SMARTHOST_AUTH_PASSWORD password_123

# RUN sed -i '/^;clear_env = no/s/^;//' /etc/php/7.0/fpm/pool.d/www.conf

COPY . /app

RUN chmod 750 /app/bin/*

# NOT proper way of doing this in Docker, but needed to create the socket file.
# Should do this: https://github.com/phusion/baseimage-docker#adding-additional-daemons
RUN service php7.0-fpm start

RUN /app/bin/init_php.sh

ENTRYPOINT ["/app/bin/boot.sh"]

CMD ["/sbin/my_init"]
