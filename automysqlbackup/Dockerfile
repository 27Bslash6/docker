FROM funkygibbon/python

VOLUME ["/backup"]

RUN apt-get update \
 && apt-get install -y automysqlbackup

ENV BACKUP_DATABASES all
ENV BACKUP_HOST mysql
ENV BACKUP_USERNAME root
ENV BACKUP_PASSWORD root

ENV BACKUP_EMAIL root

ENV BACKUP_CRONTIME "12 5 * * *"

COPY boot.sh /etc/my_init.d/10_config.sh

RUN cp /etc/default/automysqlbackup /etc/default/automysqlbackup.dist \
 && chmod +x /etc/my_init.d/*.sh
