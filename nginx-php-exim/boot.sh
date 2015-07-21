#!/bin/bash
#
# boot.sh
# Applies docker-compose environment variables to applications on container start
#

set -e


source /root/env.default
source /root/env.user

/tests.pre

# =============================================================================
# Application is launched as $APP_USER:$APP_GROUP with specified UID and GID, 
# This simplifies editing on the host via volumes, or securing volumes from host

echo "Starting config in ${ENVIRONMENT} mode ...\n"

echo "  user:  ${APP_USER:-$DEFAULT_APP_USER} ${APP_UID:-$DEFAULT_APP_UID}"
echo "  group: ${APP_GROUP:-$DEFAULT_APP_GROUP} ${APP_GID:-$DEFAULT_APP_GID}"

# =============================================================================
# 	GROUP
# =============================================================================

# - Group sanity checks
EXISTING_GROUP_GID=$( getent group ${APP_GROUP:-$DEFAULT_APP_GROUP} | sed -r "s/${APP_GROUP:-$DEFAULT_APP_GROUP}\:x\:([[:digit:]]*):/\1/g" )

if [[ $EXISTING_GROUP_GID =~ $R_NUMBER ]] ; then 
	# Create new group
	echo "\n  * groupadd ${APP_GROUP:-$DEFAULT_APP_GROUP}"
	groupadd -r -g ${APP_GID:-$DEFAULT_APP_GID} ${APP_GROUP:-$DEFAULT_APP_GROUP}
fi

if [[ $EXISTING_GROUP_GID != APP_GID ]] ; 
	
else
	# Group exists
	# @todo test existing user logic!
	echo "  group found with gid $EXISTING_GROUP_GID"

	if [[ $EXISTING_GROUP_GID -ne ${APP_GID:-$DEFAULT_APP_GID} ]]; then
		# Existing group does not have matching GID
		APP_GID = $EXISTING_GROUP_GID
		export APP_GID

		echo "\n================================================================================\n"
		echo "\tWARNING: group has different gid $EXISTING_GROUP_GID\n"
		echo "\t         new \$APP_GID is $EXISTING_GROUP_GID (was ${APP_GID:-$EXISTING_GROUP_GID})\n\n"	
		echo "================================================================================"	
	fi
fi

# =============================================================================
# 	USER
# =============================================================================
R_NUMBER='^[0-9]+$'

# - User sanity checks
EXISTING_USER_UID=$( getent passwd ${APP_USER:-$DEFAULT_APP_USER} | sed -r "s/${APP_USER:-$DEFAULT_APP_USER}\:x\:([[:digit:]]*):.*/\1/g" )
echo $EXISTING_USER_UID

if [[ $EXISTING_USER_UID =~ $R_NUMBER ]] ; then 
	# Create new user
 	echo "\n  * useradd ${APP_USER:-$DEFAULT_APP_USER}"
	useradd -M -r -G nginx -s /usr/sbin/nologin -u ${APP_UID:-$DEFAULT_APP_UID} -g ${APP_GROUP:-$DEFAULT_APP_GROUP} ${APP_USER:-$DEFAULT_APP_USER}
else
	# User exists
	# @todo test existing user logic!

	echo "  user found with uid $EXISTING_USER_UID"

	if [[ $EXISTING_USER_UID -ne ${APP_UID:-$DEFAULT_APP_UID} ]]; then
		# Existing user does not have matching UID
		APP_UID = $EXISTING_USER_UID
		export APP_UID

		echo "================================================================================\n"
		echo "\tWARNING: User has different id $EXISTING_USER_UID\n"
		echo "\t         Setting \$APP_UID to $EXISTING_USER_UID (was ${APP_UID:-$DEFAULT_APP_UID})\n"	
		echo "================================================================================"

	fi
fi

if [[ ${CHOWN_APP_DIR} -eq "true" ]] ; then
	echo "  chown ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app /var/log/nginx"
	chown -Rf ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app /var/log/nginx
fi 

# Set log dir writable by APP_USER
# unnecessary due to group permissions?
chown -Rf ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /var/log/nginx

# =============================================================================
# 	NGINX
# =============================================================================

# set nginx user
sed -i -r "s/user\s+[a-z]+/user ${APP_USER:-$DEFAULT_APP_USER}/" /etc/nginx/nginx.conf
echo "  nginx:  user ${APP_USER:-$DEFAULT_APP_USER}"

# worker_processes = num cpu cores
procs=$(cat /proc/cpuinfo |grep processor | wc -l)
sed -i -r "s/worker_processes\s+[0-9]+/worker_processes $procs/" /etc/nginx/nginx.conf
echo "  nginx:  worker_processes = $procs"

sed -i -r "s/keepalive_timeout\s+[0-9]+/keepalive_timeout ${NGINX_KEEPALIVE_TIMEOUT:-$DEFAULT_NGINX_KEEPALIVE_TIMEOUT}/" /etc/nginx/nginx.conf
echo "  nginx:  client_max_body_size = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}"
echo "  nginx:  keepalive_timeout = ${NGINX_KEEPALIVE_TIMEOUT:-$DEFAULT_NGINX_KEEPALIVE_TIMEOUT}"

# =============================================================================
# 	PHP5-FPM
# =============================================================================

# set php-fpm user to match nginx
sed -i -r "s/^user\s*=.+$/user = ${APP_USER:-$DEFAULT_APP_USER}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/^group\s*=.+$/group = ${APP_GROUP:-$DEFAULT_APP_GROUP}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/^listen.owner\s*=.+$/listen.owner = ${APP_USER:-$DEFAULT_APP_USER}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/^listen.group\s*=.+$/listen.group = ${APP_GROUP:-$DEFAULT_APP_GROUP}/g" /etc/php5/fpm/pool.d/www.conf
echo "  php:    user:  ${APP_USER:-$DEFAULT_APP_USER}"
echo "  php:    group: ${APP_GROUP:-$DEFAULT_APP_GROUP}"

# configure php memory limit
sed -i -r "s/memory_limit\s*=\s*[0-9]+M/memory_limit = ${PHP_MEMORY_LIMIT:-$DEFAULT_PHP_MEMORY_LIMIT}/g" /etc/php5/fpm/php.ini
echo "  php:    memory_limit = ${PHP_MEMORY_LIMIT:-$DEFAULT_PHP_MEMORY_LIMIT}"

# configure php file upload limits
sed -i -r "s/upload_max_filesize\s*=\s*[0-9]+M/upload_max_filesize = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}/g" /etc/php5/fpm/php.ini
sed -i -r "s/post_max_size\s*=\s*[0-9]+M/post_max_size = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}/g" /etc/php5/fpm/php.ini
echo "  php:    upload_max_filesize = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}"
echo "  php:    post_max_size = ${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}"

# configure php process manager
sed -i -r "s/pm = \w+\s*=\s*[0-9]+/pm = ${PHP_PROCESS_MANAGER:-$DEFAULT_PHP_PROCESS_MANAGER}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.max_children\s*=\s*[0-9]+/pm.max_children = ${PHP_MAX_CHILDREN:-$DEFAULT_PHP_MAX_CHILDREN}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.start_servers\s*=\s*[0-9]+/pm.start_servers = ${PHP_START_SERVERS:-$DEFAULT_PHP_START_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.min_spare_servers\s*=\s*[0-9]+/pm.min_spare_servers =  ${PHP_MIN_SPARE_SERVERS:-$DEFAULT_PHP_MIN_SPARE_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.max_spare_servers\s*=\s*[0-9]+/pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-$DEFAULT_PHP_MAX_SPARE_SERVERS}/g" /etc/php5/fpm/pool.d/www.conf
sed -i -r "s/pm.max_requests\s*=\s*[0-9]+/pm.max_requests = ${PHP_MAX_REQUESTS:-$DEFAULT_PHP_MAX_REQUESTS}/g" /etc/php5/fpm/pool.d/www.conf
echo "  php:    pm.max_children = ${PHP_MAX_CHILDREN:-$DEFAULT_PHP_MAX_CHILDREN}"
echo "  php:    pm.start_servers = ${PHP_START_SERVERS:-$DEFAULT_PHP_START_SERVERS}"
echo "  php:    pm.min_spare_servers = ${PHP_MIN_SPARE_SERVERS:-$DEFAULT_PHP_MIN_SPARE_SERVERS}"
echo "  php:    pm.max_spare_servers = ${PHP_MAX_SPARE_SERVERS:-$DEFAULT_PHP_MAX_SPARE_SERVERS}"
echo "  php:    pm.max_requests = ${PHP_MAX_REQUESTS:-$DEFAULT_PHP_MAX_REQUESTS}"

# =============================================================================
# 	EXIM4
# =============================================================================

if [[ "${EXIM_DELIVERY_MODE:-$DEFAULT_EXIM_DELIVERY_MODE}" = "smarthost" ]] ; then	

	# -------------------------------------------------------------------------
	# 	SMARTHOST
	# -------------------------------------------------------------------------
	
	# Update PHP sendmail_path 
	sed -i -r "s/sendmail_path =.*$/sendmail_path = \/usr\/bin\/sendmail -t -f no-reply@${EXIM_SMARTHOST_MAIL_FROM:-$DEFAULT_EXIM_SMARTHOST_MAIL_FROM}/g" /etc/php5/fpm/php.ini
	echo "php:    sendmail_path = /usr/bin/sendmail -t -f no-reply@${EXIM_SMARTHOST_MAIL_FROM:-$DEFAULT_EXIM_SMARTHOST_MAIL_FROM}"

	echo "  exim4:  smarthost"

	# Configure exim4 mta smarthost to use sendgrid or mailgun
	sed -i -r "s/dc_eximconfig_configtype='[a-z]*'/dc_eximconfig_configtype='smarthost'/" /etc/exim4/update-exim4.conf.conf
	
	echo "exim4:  from:  ${EXIM_SMARTHOST_MAIL_FROM:-$DEFAULT_EXIM_SMARTHOST_MAIL_FROM}"
	sed -i -r "s/dc_readhost='.*'/dc_readhost='${EXIM_SMARTHOST_MAIL_FROM:-$DEFAULT_EXIM_SMARTHOST_MAIL_FROM}'/" /etc/exim4/update-exim4.conf.conf
	
	echo "exim4:  relay: ${EXIM_SMARTHOST:-$DEFAULT_EXIM_SMARTHOST}"
	sed -i -r "s/dc_smarthost='.*'/dc_smarthost='${EXIM_SMARTHOST:-$DEFAULT_EXIM_SMARTHOST}'/" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_hide_mailname=''/dc_hide_mailname='true'/" /etc/exim4/update-exim4.conf.conf

	# sed -i -r "s/*:.+:.+/*:${EXIM_SMARTHOST_MAIL_USERNAME}:${EXIM_SMARTHOST_MAIL_PASSWORD}" /etc/exim4/passwd.client

	echo "*:${EXIM_SMARTHOST_AUTH_USERNAME:-$DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME}:${EXIM_SMARTHOST_AUTH_PASSWORD:-$DEFAULT_EXIM_SMARTHOST_AUTH_PASSWORD}" > /etc/exim4/passwd.client

else

	# -------------------------------------------------------------------------
	# 	LOCAL
	# -------------------------------------------------------------------------

	# Update PHP sendmail_path 
	sed -i -r "s/sendmail_path =.*$/sendmail_path = \/usr\/bin\/sendmail -t -f no-reply@${VIRTUAL_HOST:-$HOSTNAME}/g" /etc/php5/fpm/php.ini
	echo "  php:    sendmail_path = /usr/bin/sendmail -t -f no-reply@${VIRTUAL_HOST:-$HOSTNAME}"
	
	echo "exim4:  local delivery"

	sed -i -r "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='local'/g" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_smarthost=.*/dc_smarthost=''/g" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_hide_mailname=.*/dc_hide_mailname='true'/g" /etc/exim4/update-exim4.conf.conf

	cat > /etc/exim4/passwd.client

fi

service exim4 restart

/tests.post 

# -----------------------------------------------------------------------------


# =============================================================================
# 	BOOT
# =============================================================================

[ $1 -eq "/sbin/my_init" ] && exec /sbin/my_init || date
