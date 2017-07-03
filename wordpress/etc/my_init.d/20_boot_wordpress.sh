#!/usr/bin/env bash
set -e

source /app/bin/colours.sh

_title "funkygibbon/wordpress"

# BOOT ENVIRONMENT CONFIGURATION


# PRE-INSTALLATION CHECKS

([ "$(ls -A /app/www)" ] && [ "${OVERWRITE_FILES,,}" != "true" ]) && _good "Destination not empty: Not installing Wordpress" && exit 0;

if [ "${OVERWRITE_FILES,,}" == "true" ]; then
    WP_FORCE=" --force "
fi

if [ "$WP_ADMIN_NAME" == "" ]; then
    _warning "WP_ADMIN_NAME is blank"
else
    _good "WP_ADMIN_NAME      $WP_ADMIN_NAME"
fi

if [ "$WP_ADMIN_USER" == "" ]; then
    _error "WP_ADMIN_USER is blank"
else
    _good "WP_ADMIN_USER      $WP_ADMIN_USER"
fi

if [ "${WP_ADMIN_EMAIL:-$ADMIN_EMAIL}" == "" ]; then
    _error "WP_ADMIN_EMAIL cannot be blank"
else
    _good "WP_ADMIN_EMAIL     ${WP_ADMIN_EMAIL:-$ADMIN_EMAIL}"
fi

if [ "$WP_ADMIN_PASS" == "" ]; then
    _warning "Generating random WP_ADMIN_PASS"
else
    _good "WP_ADMIN_PASS      ********"
fi


if [ "$WP_DB_HOST" == "mysql" ]; then
    _warning "Default WP_DB_HOST: mysql"
else
    _good "WP_DB_HOST         $WP_DB_HOST"
fi


if [ "${WP_DB_NAME:-$MYSQL_DATABASE}" == "" ]; then
    _error "WP_DB_NAME cannot be blank"
else
    _good "WP_DB_NAME         ${WP_DB_NAME:-$MYSQL_DATABASE}"
fi


if [ "${WP_DB_USER:-$MYSQL_USER}" == "" ]; then
    _error "WP_DB_USER cannot be blank"
else
    _good "WP_DB_USER         ${WP_DB_USER:-$MYSQL_USER}"
fi


if [ "${WP_DB_PASS:-$MYSQL_PASSWORD}" == "" ]; then
    _error "WP_DB_PASS cannot be blank"
fi

_good "WP_DB_PREFIX       ${WP_DB_PREFIX}"

# WORDPRESS INSTALLATION

_good "Installing Wordpress for site ${WP_HOSTNAME:-${APP_HOSTNAME:-$DEFAULT_APP_HOSTNAME}}..."

wp_install() {

    mkdir -p /app/www
    chown -R ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www

    _good "wp core download ..."

    wp core download --path=/app/www --locale=${WP_LOCALE} --version=${WP_VERSION}

    _good "wp core config ..."

    wp core config --skip-check --dbname=${WP_DB_NAME:-$MYSQL_DATABASE} --dbhost=$WP_DB_HOST --dbuser=${WP_DB_USER:-$MYSQL_USER} --dbpass=${WP_DB_PASS:-$MYSQL_PASSWORD} --dbprefix=${WP_DB_PREFIX} --dbcharset=${WP_DB_CHARSET} --locale=${WP_LOCALE} ${WP_FORCE} --extra-php <<PHP
define( 'WP_DEBUG', false );
define( 'WP_DEBUG_LOG', false );

define('FS_METHOD','direct');
define('FS_CHMOD_FILE', 0664);
define('FS_CHMOD_DIR', 0775);
define('WP_TEMP_DIR', sys_get_temp_dir());
PHP

    if [ "${WP_HOSTNAME:-$APP_HOSTNAME}" == "" ]; then
        _warning "WP_HOSTNAME and APP_HOSTNAME are undefined, falling back to $(hostname)"
        export WP_HOSTNAME=$(hostname)
    fi

    _good "wp core install ..."

    wp core install --url=http://${WP_HOSTNAME:-$APP_HOSTNAME}/ --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL:-$ADMIN_EMAIL}

    wp option set siteurl "http://${WP_HOSTNAME:-$APP_HOSTNAME}/"
    wp option set home "http://${WP_HOSTNAME:-$APP_HOSTNAME}/"

}

plugin_install() {
    IFS=';' read -ra PLUGIN <<< "$WP_PLUGINS"
    for i in "${PLUGIN[@]}"; do
        wp plugin install --activate "$i"
    done
}

theme_install() {
    # HTTPS links
    if [ "$WP_THEME_HTTP" != "" ]; then
        if [ "$WP_THEME_USERNAME" == "" ] || [ "$WP_THEME_PASSWORD" == "" ]; then
            wp theme install --activate $WP_THEME
        else
            _good "Downloading theme from $WP_THEME ..."
            curl --user $WP_THEME_USERNAME:$WP_THEME_PASSWORD $WP_THEME -o /app/theme.zip
            wp theme install --activate /app/theme.zip
        fi
    fi

    if [ "$WP_THEME_GIT" != "" ]; then
        ssh-keyscan -H bitbucket.org >> ~/.ssh/known_hosts
        ssh-keyscan -H github.com >> ~/.ssh/known_hosts
        _good "Cloning $WP_THEME_GIT into /app/www/wp-content/themes/theme"
        git clone $WP_THEME_GIT /app/www/wp-content/themes/theme
        wp theme activate theme
        return 0;
    fi
}


wp_install

plugin_install

theme_install

