FROM funkygibbon/nginx-pagespeed

MAINTAINER Ray Walker <hello@raywalker.it>

RUN wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    sh -c 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list' && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
		  exim4 \
  		php \
  		php-cli \
  		php-curl \
      php-fpm \
  		php-gd \
  		php-imagick \
  		php-imap \
      php-intl \
      php-mbstring \
  		php-mcrypt \
      php-mysql \
      php-memcached \
      php-memcache \
      php-recode \
      php-redis \
      php-soap \
  		php-xdebug \
  		php-xml \
  		php-xsl \
  		php-zip \
	    newrelic-php5 && \
    newrelic-install install && \
  	apt-get clean && \
      rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN mkdir /root/bin/ && \
	echo "export PATH=/root/bin:$PATH" > /root/.bashrc

EXPOSE 443
EXPOSE 80

ENV PHP_VERSION 7.0

ENV DEFAULT_ADMIN_EMAIL nobody@example.com
ENV DEFAULT_APP_ENV production
ENV DEFAULT_CHOWN_APP_DIR false
ENV DEFAULT_VIRTUAL_HOST example.com
ENV DEFAULT_APP_HOSTNAME example.com
ENV DEFAULT_APP_USER app
ENV DEFAULT_APP_GROUP app
ENV DEFAULT_APP_UID 1000
ENV DEFAULT_APP_GID 1000
ENV DEFAULT_UPLOAD_MAX_SIZE 30M
ENV DEFAULT_NGINX_MAX_WORKER_PROCESSES 8
ENV DEFAULT_NGINX_KEEPALIVE_TIMEOUT 30
ENV DEFAULT_NGINX_FASTCGI_BACKEND unix:/run/php/php7.0-fpm.sock
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
ENV DEFAULT_PHP_CLEAR_ENV yes
ENV DEFAULT_EXIM_DELIVERY_MODE local
ENV DEFAULT_EXIM_MAIL_FROM example.com
ENV DEFAULT_EXIM_SMARTHOST smtp.example.org::587
ENV DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME postmaster@example.com
ENV DEFAULT_EXIM_SMARTHOST_AUTH_PASSWORD password_123
ENV DEFAULT_NEWRELIC_ENABLED true
ENV DEFAULT_NEWRELIC_LICENSE DISABLED

COPY . /app

RUN chmod 750 /app/bin/* && \
    sync && \
    /app/bin/init_php.sh && \
    /app/bin/install_composer.sh && \
    cp /app/bin/composer.sh /usr/local/bin/composer

ENTRYPOINT ["/app/bin/boot.sh"]

CMD ["/sbin/my_init"]
