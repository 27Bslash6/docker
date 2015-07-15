FROM phusion/baseimage:latest
MAINTAINER Ray Walker <hello@raywalker.it>

# Tell the conatiner there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Automatic mirrored sources list
COPY sources.list /etc/apt/sources.list

# Update to latest (usually unnecessary since we're using phusion's latest automatic build)
RUN apt-get update -q \
  && apt-get -y upgrade \
  && apt-get -y autoremove \
  && apt-get -y clean \
  && rm -rf /tmp/* /var/tmp/*