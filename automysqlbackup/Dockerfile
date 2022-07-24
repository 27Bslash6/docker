FROM funkygibbon/ubuntu:0.1.1

VOLUME ["/backup"]

RUN install_clean automysqlbackup

ENV \
    COMPRESSION="bzip2" \
    CRON_SCHEDULE="10 0 * * *" \
    DATABASES="all" \
    DBHOST="mysql" \
    EMAIL_CONTENT="log" \
    EMAIL_FROM="no-reply@example.com" \
    EMAIL_TO="" \
    PASSWORD="root" \
    USERNAME="root"

COPY . /app/

RUN cp /etc/default/automysqlbackup /etc/default/automysqlbackup.dist
