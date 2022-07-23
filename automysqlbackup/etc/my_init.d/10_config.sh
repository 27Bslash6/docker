#!/usr/bin/env bash
set -euo pipefail

AUTOMYSQLBACKUP_CONFIG_FILE=/etc/default/automysqlbackup
MYSQL_CONFIG_FILE=/etc/mysql/debian.cnf

sed -i -r "s#BACKUPDIR=.*#BACKUPDIR=\"/backup\"#g" $AUTOMYSQLBACKUP_CONFIG_FILE

_title "Configuring AutoMySQLBackup ..."

_good "host:      ${DBHOST}"
sed -i -r "s#DBHOST=localhost#DBHOST=${DBHOST}#g" $AUTOMYSQLBACKUP_CONFIG_FILE

_good "username:  ${USERNAME}"
echo -e "[client]\nuser = ${USERNAME}\npassword = ${PASSWORD}\nhost = ${DBHOST}\nport = 3306" > $MYSQL_CONFIG_FILE

_good "databases: ${DATABASES//,/ }"
if [[ ${DATABASES} = "all" ]]; then
    sed -i -r "s#^DBNAMES=.*#DBNAMES=\"$(mysql --defaults-file=/etc/mysql/debian.cnf --execute="SHOW DATABASES" | awk '{print $1}' | grep -v ^Database$ | grep -v ^mysql$ | grep -v ^performance_schema$ | grep -v ^information_schema$ | tr \\r\\n ,\ )\"#g" $AUTOMYSQLBACKUP_CONFIG_FILE
else
    sed -i -r "s#^DBNAMES=.*#DBNAMES=\"${DATABASES//,/ }\"#g" $AUTOMYSQLBACKUP_CONFIG_FILE
fi

_good "schedule:  ${CRON_SCHEDULE}"
(crontab -u root -l 2>/dev/null || true; echo "${CRON_SCHEDULE} automysqlbackup.sh" ) | crontab -u root -

if [[ -n "${EMAIL_TO:-}" ]]; then
  _good "email:     ${EMAIL_TO}"
  sed -i -r "s#MAILADDR=.*#MAILADDR=${EMAIL_TO}#g" $AUTOMYSQLBACKUP_CONFIG_FILE
else
  _warning "EMAIL_TO not set, will not send emails"
fi
