FROM funkygibbon/nginx-pagespeed:latest

LABEL maintainer "Ray Walker <hello@raywalker.it>" 

ENV PHP_VERSION 8.2
ENV NR_INSTALL_SILENT true

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

ENV PHP_ENABLED true

ENV ADMIN_EMAIL nobody@example.com
ENV APP_ENV production
ENV CHOWN_APP_DIR false
ENV APP_HOSTNAME example.com
ENV APP_USER app
ENV APP_GROUP app
ENV APP_UID 1000
ENV APP_GID 1000
ENV CLOUDFLARE_ENABLED true
ENV UPLOAD_MAX_SIZE 30M
ENV NGINX_MAX_WORKER_PROCESSES 4
ENV NGINX_KEEPALIVE_TIMEOUT 30
ENV PHP_MEMORY_LIMIT 192M
ENV PHP_MAX_EXECUTION_TIME 300
ENV PHP_MAX_INPUT_VARS 2000
ENV PHP_SESSION_SAVE_HANDLER "files"
ENV PHP_SESSION_SAVE_PATH "/var/lib/php/sessions"
ENV PAGESPEED_ENABLED "false"
ENV PAGESPEED_REBEACON_KEY "uwuudeL7iedoo7Meengi"
ENV PAGESPEED_REDIS_SERVER "redis:6379"
ENV PAGESPEED_REWRITE_LEVEL "CoreFilters"
ENV PAGESPEED_STATISTICS_ENABLED "off"
ENV PHP_PROCESS_MANAGER dynamic
ENV PHP_PROCESS_MANAGER_MAX_CHILDREN 6
ENV PHP_PROCESS_MANAGER_START_SERVERS 3
ENV PHP_PROCESS_MANAGER_MIN_SPARE_SERVERS 2
ENV PHP_PROCESS_MANAGER_MAX_SPARE_SERVERS 3
ENV PHP_PROCESS_MANAGER_MAX_REQUESTS 500
ENV PHP_DISABLE_FUNCTIONS false
ENV PHP_XDEBUG_REMOTE_HOST 172.17.42.1
ENV PHP_XDEBUG_REMOTE_PORT 9000
ENV PHP_XDEBUG_IDE_KEY default_ide_key
ENV PHP_CLEAR_ENV yes

ENV PHP_HEALTH_CHECK_PATH /health-check
ENV PHP_HEALTH_CHECK_RESPONSE "ok"

ENV EXIM_DELIVERY_MODE local
ENV EXIM_MAIL_FROM example.com
ENV EXIM_SMARTHOST smtp.example.org::587
ENV EXIM_SMARTHOST_AUTH_USERNAME postmaster@example.com
ENV EXIM_SMARTHOST_AUTH_PASSWORD password_123

ENV NEWRELIC_ENABLED true
ENV NEWRELIC_LICENSE DISABLED

COPY . /app/

RUN chmod 750 /app/bin/*

RUN /app/bin/init_php.sh
