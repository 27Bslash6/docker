#!/bin/bash
#
# boot.sh
# Applies docker-compose environment variables to applications on container start
#

set -e

# Source changes to env file
source /root/.env.user

echo "Starting config in ${APP_ENV:-$DEFAULT_APP_ENV} mode ..."

# env | grep DEFAULT_

# Overwrite 'example.com' default host with something appropriate
export DEFAULT_VIRTUAL_HOST=${VIRTUAL_HOST:-`hostname -f`}

echo " * host:   ${VIRTUAL_HOST:-$DEFAULT_VIRTUAL_HOST}"

# =============================================================================
# 	HHVM
# =============================================================================

# # set php-fpm user to match nginx

# @todo - switch hhvm to socket once 
# echo " * php:    user:  ${APP_USER:-$DEFAULT_APP_USER}"
# echo " * php:    group: ${APP_GROUP:-$DEFAULT_APP_GROUP}"
# sed -i -r "s/^user\s*=.+$/user = ${APP_USER:-$DEFAULT_APP_USER}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/^group\s*=.+$/group = ${APP_GROUP:-$DEFAULT_APP_GROUP}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/^listen.owner\s*=.+$/listen.owner = ${APP_USER:-$DEFAULT_APP_USER}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/^listen.group\s*=.+$/listen.group = ${APP_GROUP:-$DEFAULT_APP_GROUP}/g" /etc/php5/fpm/pool.d/www.conf

# # configure php process manager
# echo " * php:    pm.max_children = ${PHP_MAX_CHILDREN:-$DEFAULT_PHP_MAX_CHILDREN}"
# echo " * php:    pm.start_servers = ${PHP_START_SERVERS:-$DEFAULT_PHP_START_SERVERS}"
# echo " * php:    pm.min_spare_servers = ${PHP_MIN_SPARE_SERVERS:-$DEFAULT_PHP_MIN_SPARE_SERVERS}"
# echo " * php:    pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-$DEFAULT_PHP_MAX_SPARE_SERVERS}"
# echo " * php:    pm.max_requests = ${PHP_MAX_REQUESTS:-$DEFAULT_PHP_MAX_REQUESTS}"
# sed -i -r "s/pm = \w+\s*=\s*[0-9]+/pm = ${PHP_PROCESS_MANAGER:-$DEFAULT_PHP_PROCESS_MANAGER}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/pm.max_children\s*=\s*[0-9]+/pm.max_children = ${PHP_MAX_CHILDREN:-$DEFAULT_PHP_MAX_CHILDREN}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/pm.start_servers\s*=\s*[0-9]+/pm.start_servers = ${PHP_START_SERVERS:-$DEFAULT_PHP_START_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/pm.min_spare_servers\s*=\s*[0-9]+/pm.min_spare_servers =  ${PHP_MIN_SPARE_SERVERS:-$DEFAULT_PHP_MIN_SPARE_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/pm.max_spare_servers\s*=\s*[0-9]+/pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-$DEFAULT_PHP_MAX_SPARE_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
# sed -i -r "s/pm.max_requests\s*=\s*[0-9]+/pm.max_requests = ${PHP_MAX_REQUESTS:-$DEFAULT_PHP_MAX_REQUESTS}/g" /etc/php5/fpm/pool.d/www.conf


# # Update PHP sendmail_path 
# echo " * php:    sendmail_path = /usr/bin/sendmail -t -f no-reply@${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}"
# sed -i -r "s/sendmail_path =.*$/sendmail_path = \/usr\/sbin\/sendmail -t -f no-reply@${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}/g" /etc/php5/fpm/php.ini

# =============================================================================
# 	EXIM4
# =============================================================================

if [[ "${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}" = "example.com" ]] ; then
	# echo " * exim:   mail_from ${VIRTUAL_HOST:-$DEFAULT_VIRTUAL_HOST}"
	EXIM_MAIL_FROM=${VIRTUAL_HOST:-$DEFAULT_VIRTUAL_HOST}
fi

if [[ "${EXIM_DELIVERY_MODE:-$DEFAULT_EXIM_DELIVERY_MODE}" = "smarthost" ]] ; then	

	# -------------------------------------------------------------------------
	# 	SMARTHOST
	# -------------------------------------------------------------------------
	
	echo " * exim4:  smarthost"
	
	if [[ "${EXIM_SMARTHOST_AUTH_USERNAME:-$DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME}" = "postmaster@example.com" ]] ; then

		echo "ERROR:   exim4:  Your username is 'postmaster@example.com'"
		echo " *               Please rebuild using EXIM_SMARTHOST_AUTH_USERNAME and EXIM_SMARTHOST_AUTH_PASSWORD"
		echo " *               $ docker run -e \"EXIM_SMARTHOST_AUTH_USERNAME=foo\" etc"

	else

		echo " * exim4:  *:${EXIM_SMARTHOST_AUTH_USERNAME:-$DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME}:********"

		echo "*:${EXIM_SMARTHOST_AUTH_USERNAME:-$DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME}:${EXIM_SMARTHOST_AUTH_PASSWORD:-$DEFAULT_EXIM_SMARTHOST_AUTH_PASSWORD}" > /etc/exim4/passwd.client
		# Configure exim4 mta smarthost to use sendgrid or mailgun
		sed -i -r "s/dc_eximconfig_configtype='[a-z]*'/dc_eximconfig_configtype='smarthost'/" /etc/exim4/update-exim4.conf.conf
		
		echo " * exim4:  relay: ${EXIM_SMARTHOST:-$DEFAULT_EXIM_SMARTHOST}"
		sed -i -r "s/dc_smarthost=.*/dc_smarthost='${EXIM_SMARTHOST:-$DEFAULT_EXIM_SMARTHOST}'/" /etc/exim4/update-exim4.conf.conf
				
		echo " * exim4:  from:  ${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}"
		sed -i -r "s/dc_readhost='.*'/dc_readhost='${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}'/" /etc/exim4/update-exim4.conf.conf
		

		sed -i -r "s/dc_hide_mailname=''/dc_hide_mailname='true'/" /etc/exim4/update-exim4.conf.conf

		# sed -i -r "s/*:.+:.+/*:${EXIM_SMARTHOST_MAIL_USERNAME}:${EXIM_SMARTHOST_MAIL_PASSWORD}" /etc/exim4/passwd.client
	
	fi

	
else

	# -------------------------------------------------------------------------
	# 	LOCAL
	# -------------------------------------------------------------------------

	# # Update PHP sendmail_path 
	# sed -i -r "s/sendmail_path =.*$/sendmail_path = \/usr\/bin\/sendmail -t -f no-reply@${EXIM_MAIL_FROM}/g" /etc/php5/fpm/php.ini
	# echo " * php:    sendmail_path = /usr/bin/sendmail -t -f no-reply@${EXIM_MAIL_FROM}"
	
	echo " * exim4:  local"

	sed -i -r "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='local'/g" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_smarthost=.*/dc_smarthost=''/g" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_hide_mailname=.*/dc_hide_mailname='true'/g" /etc/exim4/update-exim4.conf.conf

	echo " * exim4:  rm /etc/exim4/passwd.client"
	rm /etc/exim4/passwd.client

fi

service exim4 restart

# -----------------------------------------------------------------------------


# =============================================================================
# 	BOOT
# =============================================================================

echo -e "\nDone\n$(date)\n"

if [[ "$1" = "/sbin/my_init" ]] ; then
	exec /sbin/my_init 
else
	echo "$ /bin/sh -c $1"
	exec /bin/sh -c $1
fi
