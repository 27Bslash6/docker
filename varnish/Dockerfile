FROM funkygibbon/ubuntu:xenial

RUN apt-get update && \
  apt-get -y install varnish && \
  apt-get -y clean && \
  rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV VARNISH_PORT 80
ENV VARNISH_MEMORY 100M

EXPOSE 80

COPY . /app

RUN chmod 750 /app/bin/*.sh && sync && \
    /app/bin/init_varnish.sh

CMD ["/sbin/my_init"]
