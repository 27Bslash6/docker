#!/bin/bash
#
# boot.sh
# Applies docker-compose environment variables to applications on container start
# Restarts appropriate services (only exim4 at this point)

set -e

source /root/.env.user

echo "Starting config in ${APP_ENV:-$DEFAULT_APP_ENV} mode ..."

# env | grep DEFAULT_

# Overwrite 'example.com' default host with something appropriate
export DEFAULT_VIRTUAL_HOST=${VIRTUAL_HOST:-`hostname -f`}

echo " * host:   ${VIRTUAL_HOST:-$DEFAULT_VIRTUAL_HOST}"

# =============================================================================
# Application is launched as $APP_USER:$APP_GROUP with specified UID and GID, 
# This simplifies editing on the host via volumes, or securing volumes from host


echo " * user:   ${APP_USER:-$DEFAULT_APP_USER} ${APP_UID:-$DEFAULT_APP_UID}"
echo " * group:  ${APP_GROUP:-$DEFAULT_APP_GROUP} ${APP_GID:-$DEFAULT_APP_GID}"

# Regex to detect an integer
R_NUMBER='^[0-9]+$'

# =============================================================================
# 	GROUP
# =============================================================================

# - Group sanity checks


EXISTING_GROUP_GID=$( getent group ${APP_GROUP:-$DEFAULT_APP_GROUP} | sed -r "s/${APP_GROUP:-$DEFAULT_APP_GROUP}\:x\:([[:digit:]]*):/\1/g" )

if [[ $EXISTING_GROUP_GID =~ $R_NUMBER ]] ; then 
	# Is number, is good.

	# Group exists
	# @todo test existing user logic!

	echo " * - group found with gid $EXISTING_GROUP_GID"

	if ! [[ "$EXISTING_GROUP_GID" = "${APP_GID:-$DEFAULT_APP_GID}" ]]; then
		# Existing group does not have matching GID
		APP_GID = $EXISTING_GROUP_GID
		export APP_GID

		echo "\n================================================================================\n"
		echo "\tWARNING: group has different gid $EXISTING_GROUP_GID\n"
		echo "\t         new \$APP_GID is $EXISTING_GROUP_GID (was ${APP_GID:-$EXISTING_GROUP_GID})\n\n"	
		echo "================================================================================"	
	fi
	
else

	# Create new group
	echo " * - groupadd ${APP_GROUP:-$DEFAULT_APP_GROUP}"
	groupadd -r -g ${APP_GID:-$DEFAULT_APP_GID} ${APP_GROUP:-$DEFAULT_APP_GROUP}

fi

# =============================================================================
# 	USER
# =============================================================================


# - User sanity checks
EXISTING_USER_UID=$( getent passwd ${APP_USER:-$DEFAULT_APP_USER} | sed -r "s/${APP_USER:-$DEFAULT_APP_USER}\:x\:([[:digit:]]*):.*/\1/g" )
if ! [[ -z "$EXISTING_USER_UID" ]] ; then
	echo "**  - debug: user search result"
	echo $EXISTING_USER_UID
fi

if [[ $EXISTING_USER_UID =~ $R_NUMBER ]] ; then 
	# User exists
	# @todo test existing user logic!

	echo " * - user found with uid $EXISTING_USER_UID"

	if ! [[ "$EXISTING_USER_UID" = "${APP_UID:-$DEFAULT_APP_UID}" ]]; then
		# Existing user does not have matching UID
		APP_UID = $EXISTING_USER_UID
		export APP_UID

		echo "================================================================================\n"
		echo "\tWARNING: User has different id $EXISTING_USER_UID\n"
		echo "\t         Setting \$APP_UID to $EXISTING_USER_UID (was ${APP_UID:-$DEFAULT_APP_UID})\n"	
		echo "================================================================================"

	fi

else
	# Create new user
 	echo " * - useradd ${APP_USER:-$DEFAULT_APP_USER}"
	useradd -r -s /usr/sbin/nologin -G nginx -u ${APP_UID:-$DEFAULT_APP_UID} -g ${APP_GROUP:-$DEFAULT_APP_GROUP} ${APP_USER:-$DEFAULT_APP_USER}
fi

if [[ "${CHOWN_APP_DIR:-$DEFAULT_CHOWN_APP_DIR}" -eq "true" ]] ; then
	echo " * - chown ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www"
	chown -Rf ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www
fi 

# =============================================================================
# 	PHP5-FPM
# =============================================================================

# set php-fpm user to match nginx
echo " * php:    user:  ${APP_USER:-$DEFAULT_APP_USER}"
echo " * php:    group: ${APP_GROUP:-$DEFAULT_APP_GROUP}"
sed -i -r "s/^user\s*=.+$/user = ${APP_USER:-$DEFAULT_APP_USER}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/^group\s*=.+$/group = ${APP_GROUP:-$DEFAULT_APP_GROUP}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/^listen.owner\s*=.+$/listen.owner = ${APP_USER:-$DEFAULT_APP_USER}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/^listen.group\s*=.+$/listen.group = ${APP_GROUP:-$DEFAULT_APP_GROUP}/g" /etc/php5/fpm/pool.d/www.conf

# configure php memory limit
echo " * php:    memory_limit = ${PHP_MEMORY_LIMIT:-$DEFAULT_PHP_MEMORY_LIMIT}"
sed -i -r "s/memory_limit\s*=\s*[0-9]+M/memory_limit = ${PHP_MEMORY_LIMIT:-$DEFAULT_PHP_MEMORY_LIMIT}/g" /etc/php5/fpm/php.ini

# configure php file upload limits
echo " * php:    upload_max_filesize = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}"
echo " * php:    post_max_size = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}"
sed -i -r "s/upload_max_filesize\s*=\s*[0-9]+M/upload_max_filesize = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}/g" /etc/php5/fpm/php.ini
sed -i -r "s/post_max_size\s*=\s*[0-9]+M/post_max_size = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}/g" /etc/php5/fpm/php.ini

# configure php process manager
echo " * php:    pm.max_children = ${PHP_MAX_CHILDREN:-$DEFAULT_PHP_MAX_CHILDREN}"
echo " * php:    pm.start_servers = ${PHP_START_SERVERS:-$DEFAULT_PHP_START_SERVERS}"
echo " * php:    pm.min_spare_servers = ${PHP_MIN_SPARE_SERVERS:-$DEFAULT_PHP_MIN_SPARE_SERVERS}"
echo " * php:    pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-$DEFAULT_PHP_MAX_SPARE_SERVERS}"
echo " * php:    pm.max_requests = ${PHP_MAX_REQUESTS:-$DEFAULT_PHP_MAX_REQUESTS}"
sed -i -r "s/pm = \w+\s*=\s*[0-9]+/pm = ${PHP_PROCESS_MANAGER:-$DEFAULT_PHP_PROCESS_MANAGER}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.max_children\s*=\s*[0-9]+/pm.max_children = ${PHP_MAX_CHILDREN:-$DEFAULT_PHP_MAX_CHILDREN}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.start_servers\s*=\s*[0-9]+/pm.start_servers = ${PHP_START_SERVERS:-$DEFAULT_PHP_START_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.min_spare_servers\s*=\s*[0-9]+/pm.min_spare_servers =  ${PHP_MIN_SPARE_SERVERS:-$DEFAULT_PHP_MIN_SPARE_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.max_spare_servers\s*=\s*[0-9]+/pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-$DEFAULT_PHP_MAX_SPARE_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.max_requests\s*=\s*[0-9]+/pm.max_requests = ${PHP_MAX_REQUESTS:-$DEFAULT_PHP_MAX_REQUESTS}/g" /etc/php5/fpm/pool.d/www.conf

if [[ "${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}" = "example.com" ]] ; then
	# echo " * exim:   mail_from ${VIRTUAL_HOST:-$DEFAULT_VIRTUAL_HOST}"
	EXIM_MAIL_FROM=${VIRTUAL_HOST:-$DEFAULT_VIRTUAL_HOST}
fi

# Update PHP sendmail_path 
echo " * php:    sendmail_path = /usr/bin/sendmail -t -f no-reply@${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}"
sed -i -r "s/sendmail_path =.*$/sendmail_path = \/usr\/sbin\/sendmail -t -f no-reply@${EXIM_MAIL_FROM:-$DEFAULT_EXIM_MAIL_FROM}/g" /etc/php5/fpm/php.ini

# =============================================================================
# 	EXIM4
# =============================================================================


if [[ "${EXIM_DELIVERY_MODE:-$DEFAULT_EXIM_DELIVERY_MODE}" = "smarthost" ]] ; then	

	# -------------------------------------------------------------------------
	# 	SMARTHOST
	# -------------------------------------------------------------------------
	
	echo " * exim4:  smarthost"
	
	if [[ "${EXIM_SMARTHOST_AUTH_USERNAME:-$DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME}" = "postmaster@example.com" ]] ; then

		echo "ERROR:   exim4:  Your username is 'postmaster@example.com'"
		echo " *                Please rebuild using EXIM_SMARTHOST_AUTH_USERNAME and EXIM_SMARTHOST_AUTH_PASSWORD"
		echo " *                $ docker run -e \"EXIM_SMARTHOST_AUTH_USERNAME=foo\" etc"

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
