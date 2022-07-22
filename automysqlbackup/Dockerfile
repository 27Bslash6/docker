FROM funkygibbon/ubuntu:focal-0.0.1

VOLUME ["/backup"]

RUN install_clean automysqlbackup

ENV DATABASES "all"
ENV DBHOST "mysql"
ENV USERNAME "root"
ENV PASSWORD "root"

ENV EMAIL_TO ""
ENV EMAIL_FROM "no-reply@example.com"
ENV HOSTNAME "docker"

ENV MAILGUN_API_KEY ""
ENV MAILGUN_DOMAIN ""

ENV CRON_SCHEDULE "10 0 * * *"

COPY config.sh /etc/my_init.d/10_config.sh

RUN echo "EXTRA_OPTS='-L /proc/1/fd/1'" >> /etc/default/cron

RUN cp /etc/default/automysqlbackup /etc/default/automysqlbackup.dist \
    && chmod +x /etc/my_init.d/*.sh
