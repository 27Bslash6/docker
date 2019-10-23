FROM funkygibbon/nginx-pagespeed

MAINTAINER Ray Walker <hello@raywalker.it>

ENV PHP_VERSION 7.3

RUN wget --retry-connrefused --waitretry=1 -t 5 -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list && \
    add-apt-repository ppa:ondrej/php && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
      newrelic-php5 \
      php${PHP_VERSION} \
      php${PHP_VERSION}-cli \
      php${PHP_VERSION}-curl \
      php${PHP_VERSION}-fpm \
      php${PHP_VERSION}-gd \
      php${PHP_VERSION}-imagick \
      php${PHP_VERSION}-mbstring \
      php${PHP_VERSION}-mysql \
      php${PHP_VERSION}-recode \
      php${PHP_VERSION}-redis \
      php${PHP_VERSION}-xml \
      php${PHP_VERSION}-zip \
      exim4 \
  		newrelic-php5 \
      && \
  newrelic-install install && \
	apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN mkdir /root/bin/ && \
	echo "export PATH=/root/bin:$PATH" > /root/.bashrc

EXPOSE 443
EXPOSE 80


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

COPY . /app/

RUN chmod 750 /app/bin/*

RUN /app/bin/init_php.sh
