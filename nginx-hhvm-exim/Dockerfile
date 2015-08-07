FROM funkygibbon/nginx-pagespeed

MAINTAINER Ray Walker <hello@raywalker.it>

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0x5a16e7281be7a449 && \
	add-apt-repository "deb http://dl.hhvm.com/ubuntu $(lsb_release -sc) main" && \
	apt-get update && \
	apt-get install -y hhvm exim4 && \
	apt-get clean

RUN mkdir /root/bin/ && \
	echo "export PATH=/root/bin:$PATH" > /root/.bashrc

EXPOSE 443
EXPOSE 80

ENV DEFAULT_APP_ENV production
ENV DEFAULT_CHOWN_APP_DIR true
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
ENV DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME postmaster@example.com
ENV DEFAULT_EXIM_SMARTHOST_AUTH_PASSWORD password_123

COPY . /app

RUN chmod 750 /app/bin/*

RUN /app/bin/init_hhvm.sh

ENTRYPOINT ["/app/bin/boot.sh"]

CMD ["/sbin/my_init"]