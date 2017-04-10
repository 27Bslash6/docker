FROM funkygibbon/nginx-php-exim:latest

RUN ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts && \
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts && \
    apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

COPY . /app/

WORKDIR /app

RUN rm -fr /app/www && mkdir /app/www && \
    cp -R etc/* /etc/ && \
    chmod +x /etc/my_init.d/20_boot_wordpress.sh && \
    cp bin/wp.sh /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

RUN [ -f /app/wp-cli.phar ] || curl -o /app/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# If set to true then will install Wordpress in /app/www overwriting any contents
ENV OVERWRITE_FILES "false"

ENV WP_TITLE "funkygibbon/wordpress"

ENV WP_HOSTNAME ""


ENV WP_DB_HOST "mysql"
ENV WP_DB_NAME ""
ENV WP_DB_USER ""
ENV WP_DB_PASS ""
ENV WP_DB_PREFIX "wordpress_"

ENV WP_PLUGINS "wordfence;debug-bar"

ENV WP_ADMIN_NAME ""
ENV WP_ADMIN_USER ""
ENV WP_ADMIN_PASS ""
ENV WP_ADMIN_EMAIL ""

ENV WP_VERSION "latest"
ENV WP_LOCALE "en_AU"

ENV WP_THEME_HTTP ""
ENV WP_THEME_GIT ""
ENV WP_THEME_USERNAME ""
ENV WP_THEME_PASSWORD ""

ENV SSH_DOMAIN_HOSTKEYS ""

