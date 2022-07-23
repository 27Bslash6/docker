FROM funkygibbon/ubuntu:0.1.1

VOLUME ["/backup"]

RUN install_clean automysqlbackup

ENV \
    CRON_SCHEDULE="10 0 * * *" \
    DATABASES="all" \
    DBHOST="mysql" \
    PASSWORD="root" \
    USERNAME="root"

ENV EMAIL_TO ""
ENV EMAIL_FROM "no-reply@example.com"
ENV MAILGUN_API_KEY ""
ENV MAILGUN_DOMAIN ""

COPY . /app/

RUN cp /etc/default/automysqlbackup /etc/default/automysqlbackup.dist
