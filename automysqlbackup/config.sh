#!/usr/bin/env bash

AUTOMYSQLBACKUP_CONFIG_FILE=/etc/default/automysqlbackup
MYSQL_CONFIG_FILE=/etc/mysql/debian.cnf

sed -i -r "s/BACKUPDIR=.*/BACKUPDIR=\"\/backup\"/g" $AUTOMYSQLBACKUP_CONFIG_FILE

echo " * host:      ${BACKUP_HOST}"
sed -i -r "s/DBHOST=localhost/DBHOST=${BACKUP_HOST}/g" $AUTOMYSQLBACKUP_CONFIG_FILE

echo " * databases: ${BACKUP_DATABASES//,/ }"
if [[ ${BACKUP_DATABASES} = "all" ]]; then
    sed -i -r "s/^DBNAMES=.*/DBNAMES=`mysql --defaults-file=/etc/mysql/debian.cnf --execute=\"SHOW DATABASES\" | awk '{print $1}' | grep -v ^Database$ | grep -v ^mysql$ | grep -v ^performance_schema$ | grep -v ^information_schema$ | tr \\\r\\\n ,\ `/g" $AUTOMYSQLBACKUP_CONFIG_FILE
else
    sed -i -r "s/^DBNAMES=.*/DBNAMES=\"${BACKUP_DATABASES//,/ }\"/g" $AUTOMYSQLBACKUP_CONFIG_FILE
fi

echo " * username:  ${BACKUP_USERNAME}"
echo -e "[client]\nuser = ${BACKUP_USERNAME}\npassword = ${BACKUP_PASSWORD}\nhost = ${BACKUP_HOST}\nport = 3306" > $MYSQL_CONFIG_FILE


echo " * email:     ${BACKUP_EMAIL}"
sed -i -r "s/MAILADDR=.*/MAILADDR=${BACKUP_EMAIL}/g" $AUTOMYSQLBACKUP_CONFIG_FILE



