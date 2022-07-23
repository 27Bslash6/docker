FROM phusion/baseimage:focal-1.2.0 as base

COPY . /app/

RUN mv /etc/apt/sources.list /etc/apt/sources.list.original \
    && ln -s /app/sources.list /etc/apt/sources.list \
    && add-apt-repository ppa:apt-fast/stable \
    && apt-get update \
    && apt-get -y install --no-install-recommends apt-fast \
    && apt-fast -y upgrade \
    && apt-fast install --no-install-recommends -y \
      time \
      tzdata \
      rsync \
      wget \
    && rm -fr /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/apt-fast/* \
    && chmod 755 /app/bin/* \
    && rm -fr /usr/share/man/* /usr/share/doc/* \
    && ln -s /app/bin/set_timezone.sh /etc/my_init.d/00_set_timezone.sh \
    && wget -nv https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz \
    && tar -C /app/bin -xzvf dockerize-linux-amd64-v0.6.1.tar.gz \
    && rm dockerize-linux-amd64-v0.6.1.tar.gz \
    && rm -fr /etc/service/sshd

FROM scratch

COPY --from=base / /

ENV \
    APP_ENV="production" \
    APP_GID="1000" \
    APP_GROUP="app" \
    APP_HOSTNAME="example.com" \
    APP_UID="1000" \
    APP_USER="app" \
    CONTAINER_TIMEZONE="etc/UTC" \
    DEBIAN_FRONTEND="noninteractive" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    PATH="/app/bin:$PATH"

WORKDIR /app

ENTRYPOINT ["/app/bin/entrypoint.sh"]

CMD ["/sbin/my_init"]
