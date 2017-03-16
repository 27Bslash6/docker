#!/usr/bin/env bash
set -e

[ "$(ls -A /app/www)" ] && echo "  * /app/www is not empty" && exit 0;

wp_install() {

    mkdir -p /app/www
    cd /app/www
    chown -R ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www

#    apt-get update && apt-get install -y mysql-client
#    apt-get clean && rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

    wp core download --path=/app/www --locale=${WP_LOCALE} --version=${WP_VERSION}

    wp core config --skip-check --dbname=$WP_DB_NAME --dbhost=$WP_DB_HOST --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS \
        --locale=${WP_LOCALE}

    echo -e "\n#define( 'WP_DEBUG', true );
#define( 'WP_DEBUG_LOG', true );

define('FS_METHOD','direct');
define('FS_CHMOD_FILE', 0664);
define('FS_CHMOD_DIR', 0775);
define('WP_TEMP_DIR', sys_get_temp_dir());" >> /app/www/wp-config.php

    wp core install --url=${WP_HOSTNAME:-$APP_HOSTNAME} --title="${WP_TITLE}" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL}

    wp option set siteurl "http://${WP_HOSTNAME}/"
    wp option set home "http://${WP_HOSTNAME}/"
}

plugin_install() {
    cd /app/www

    IFS=';' read -ra PLUGIN <<< "$WP_PLUGINS"
    for i in "${PLUGIN[@]}"; do
        wp plugin install --activate "$i"
    done
}

#theme_install() {
#
#}


if [ "${INSTALL_WORDPRESS}" == "true" ]
then

    if [ "${WP_HOSTNAME:-${APP_HOSTNAME:-$DEFAULT_APP_HOSTNAME}}" == "example.com" ]
    then
        echo -e "\n  ! WARNING ! - Hostname not defined, using $(hostname). Set WP_HOSTNAME to avoid this warning \n"
        export WP_HOSTNAME=$(hostname)
    fi

    echo "  * Installing Wordpress for site ${WP_HOSTNAME:-${APP_HOSTNAME:-$DEFAULT_APP_HOSTNAME}}..."

    if [ "${WP_ADMIN_PASS}" == "funkygibbon" ]
    then
        echo -e "\n  ! ERROR ! - Refusing to install Wordpress with the default password. Please change WP_ADMIN_PASS\n"
        exit 0
    fi

    wp_install

    plugin_install

#    theme_install
fi
