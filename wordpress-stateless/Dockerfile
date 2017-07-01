FROM funkygibbon/wordpress
MAINTAINER Raymond Walker "hello@raywalker.it"

# See https://hub.docker.com/r/funkygibbon/nginx-php-exim/
ENV PHP_CLEAR_ENV no

ENV WP_PLUGINS "wordfence;debug-bar;wp-stateless"

COPY . /app

RUN cp -R /app/etc/* /etc && sync && \
    chmod +x /etc/my_init.d/*.sh