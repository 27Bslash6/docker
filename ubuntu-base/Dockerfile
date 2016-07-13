FROM phusion/baseimage:0.9.19
MAINTAINER Joost van der Laan <joost@fashionunited.com>

# Tell the conatiner there is no tty
ENV DEBIAN_FRONTEND noninteractive

ENV DEFAULT_TIMEZONE Europe/Amsterdam

# Automatic choose local mirror for sources list
COPY sources.list /etc/apt/sources.list

# Update to latest packages and tidy up
RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* 

COPY . /app

RUN chmod +x /app/bin/*

RUN ln -s /app/bin/set_timezone.sh /etc/my_init.d/00_set_timezone.sh

