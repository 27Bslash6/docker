#!/bin/bash

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
		APP_GID=$EXISTING_GROUP_GID
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
		APP_UID=$EXISTING_USER_UID
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

