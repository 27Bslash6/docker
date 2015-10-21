#!/bin/bash
#
# boot.sh
# Applies docker-compose environment variables to applications on container start
# Restarts appropriate services (only exim4 at this point)

set -e

echo "Starting config in ${APP_ENV:-$DEFAULT_APP_ENV} mode ..."

export APP_HOSTNAME=${APP_HOSTNAME:-`hostname -f`}

echo " * host:   ${APP_HOSTNAME}"

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

	fi

	
else

	# -------------------------------------------------------------------------
	# 	LOCAL
	# -------------------------------------------------------------------------
	
	echo " * exim4:  local"

	sed -i -r "s/dc_eximconfig_configtype=.*/dc_eximconfig_configtype='local'/g" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_smarthost=.*/dc_smarthost=''/g" /etc/exim4/update-exim4.conf.conf
	sed -i -r "s/dc_hide_mailname=.*/dc_hide_mailname='true'/g" /etc/exim4/update-exim4.conf.conf

	echo " * exim4:  rm /etc/exim4/passwd.client"
	rm -f /etc/exim4/passwd.client

fi

# -----------------------------------------------------------------------------
#   EXIM email redirect
# -----------------------------------------------------------------------------

if [[ "${APP_ENV:-$DEFAULT_APP_ENV}" = "development" ]]; then

	if [[ ${ADMIN_EMAIL:-$DEFAULT_ADMIN_EMAIL} = "nobody@example.com" ]]; then
		echo " ** WARNING ** admin email is default - nobody@example.com - emails will disappear into the void"
	fi

	echo " * exim4:  re-routing all outgoing email to ${ADMIN_EMAIL:-$DEFAULT_ADMIN_EMAIL}"
	echo -e "catch_all_outgoing:\n  debug_print = \"R: redirecting email for \$local_part@\$domain\"\n  driver = redirect\n  domains = ! +local_domains\n  allow_fail\n  data = ${ADMIN_EMAIL:-$DEFAULT_ADMIN_EMAIL}\n  no_more\n" > /etc/exim4/conf.d/router/190_exim4-config_intercept
	
	update-exim4.conf.template -r

else
	rm -fr /etc/exim4/conf.d/router/190_exim4-config_intercept
fi

echo " * exim4:  restarting service ..."
rm -f /etc/exim4/exim4.conf.template.bak*
service exim4 restart >> /dev/null

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
