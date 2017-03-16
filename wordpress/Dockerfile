FROM funkygibbon/nginx-php-exim:latest

COPY . /app/

WORKDIR /app

RUN rm -fr /app/www && mkdir /app/www && \
    cp -R etc/* /etc/ && \
    chmod +x /etc/my_init.d/20_boot_wordpress.sh && \
    cp bin/wp.sh /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

ENV INSTALL_WORDPRESS true

ENV WP_TITLE "funkygibbon/wordpress"

ENV WP_ADMIN_USER "funkygibbon"
ENV WP_ADMIN_PASS "funkygibbon"
ENV WP_ADMIN_EMAIL "example@example.com"

ENV WP_HOSTNAME "example.com"

ENV WP_DB_HOST DatabaseHost
ENV WP_DB_NAME DatabaseName
ENV WP_DB_USER DatabaseUsername
ENV WP_DB_PASS DatabasePassword
ENV WP_DB_PREFIX "wordpress_"

ENV WP_PLUGINS wordfence;debug-bar

ENV WP_VERSION latest
ENV WP_LOCALE en_AU

ENV THEME_REPOSITORY ""

RUN [ -f /app/wp-cli.phar ] || curl -o /app/www/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
