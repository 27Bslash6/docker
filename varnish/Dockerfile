FROM funkygibbon/ubuntu:xenial

RUN apt-get update && \
  apt-get -y install --no-install-recommends varnish && \
  apt-get -y clean && \
  rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV VARNISH_LISTEN_PORT 80
ENV VARNISH_BACKEND_PORT 80
ENV VARNISH_MEMORY 100M
ENV VARNISH_VCL_FILE /etc/varnish/default.vcl
ENV VARNISH_PROBE_INTERVAL 10s
ENV VARNISH_PROBE_TIMEOUT 5s
ENV VARNISH_GRACE_TIME 2m

EXPOSE 80

COPY . /app

RUN chmod 750 /app/bin/*.sh && sync && \
    /app/bin/init_varnish.sh

CMD ["/sbin/my_init"]
