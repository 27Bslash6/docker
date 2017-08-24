FROM funkygibbon/nginx-php-exim

RUN ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts && \
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts && \
    apt-get update && \
    apt-get install -y --no-install-recommends git mysql-client && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
    curl -o /app/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

COPY . /app/

WORKDIR /app

RUN rm -fr /app/www && mkdir /app/www && \
    cp -R etc/* /etc/ && \
    chmod +x /etc/my_init.d/20_boot_wordpress.sh && \
    cp bin/wp.sh /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

ENV WP_TITLE "funkygibbon/wordpress" \
    WP_HOSTNAME "" \
    WP_DB_HOST "mysql" \
    WP_DB_PORT "3306" \ # unused
    WP_DB_NAME "" \
    WP_DB_USER ""  \
    WP_DB_PASS "" \
    WP_DB_PREFIX "wp_" \
    WP_DB_CHARSET "utf8" \
    WP_DB_COLLATION "" \
    OVERWRITE_FILES "false" \
    WP_FORCE_SSL_ADMIN "false" \
    WP_PLUGINS "wordfence;debug-bar" \
    WP_ADMIN_NAME "" \
    WP_ADMIN_USER "" \
    WP_ADMIN_PASS "" \
    WP_ADMIN_EMAIL "" \
    WP_VERSION "latest" \
    WP_LOCALE "en_AU" \
    WP_THEME_HTTP "" \
    WP_THEME_GIT "" \
    WP_THEME_USERNAME "" \
    WP_THEME_PASSWORD "" \
    SSH_DOMAIN_HOSTKEYS ""

