#!/usr/bin/env bash

PHP_BINARY=`which php`

APP_PATH=/app/source/public

LOGROTATE_FILENAME=/app/magento-logrotate

if [ ! -f ${LOGROTATE_FILENAME} ]
then
  cat > ${LOGROTATE_FILENAME} <<EOF
/app/source/public/var/log/*.log {
    rotate 52
    weekly
    compress
    missingok
    notifempty
}
EOF
fi
# Rotate all magento logs once weekly
(crontab -l ; echo "@weekly /usr/sbin/logrotate -f ${LOGROTATE_FILENAME}")  | sort - | uniq - | crontab -

# Fix for potential kernel issue between container and host
# See: https://stackoverflow.com/questions/21926465/issues-running-cron-in-docker-on-different-hosts
sed -i -r "s/^session\s+required\s+pam_loginuid.so/# session required pam_loginuid.so/g" /etc/pam.d/cron

# Set permissions
touch ${APP_PATH}/var/log/magento.cron.log
touch ${APP_PATH}/var/log/update.cron.log
touch ${APP_PATH}/var/log/setup.cron.log

chown ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} ${APP_PATH}/var/log/*.cron.log

# Call Magento's cron tasks every minute
# See: http://devdocs.magento.com/guides/v2.0/config-guide/cli/config-cli-subcommands-cron.html
(crontab -l ; echo "* * * * * /sbin/setuser ${APP_USER:-$DEFAULT_APP_USER} ${PHP_BINARY} ${APP_PATH}/bin/magento cron:run | grep -v \"Ran jobs by schedule\" >> ${APP_PATH}/var/log/magento.cron.log")  | sort - | uniq - | crontab -
(crontab -l ; echo "* * * * * /sbin/setuser ${APP_USER:-$DEFAULT_APP_USER} ${PHP_BINARY} ${APP_PATH}/update/cron.php >> ${APP_PATH}/var/log/update.cron.log")  | sort - | uniq - | crontab -
(crontab -l ; echo "* * * * * /sbin/setuser ${APP_USER:-$DEFAULT_APP_USER} ${PHP_BINARY} ${APP_PATH}/bin/magento setup:cron:run >> ${APP_PATH}/var/log/setup.cron.log")  | sort - | uniq - | crontab -
