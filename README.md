# docker-ubuntu-base

https://registry.hub.docker.com/u/funkygibbon/docker-ubuntu-base/

Automated daily build of an Ubuntu trusty base image from https://phusion.github.io/baseimage-docker/ 

- Modified apt sources.list to use `http://mirror.rackspace.com/ubuntu/`
- Set container timezone to environment variable `${TIMEZONE:-$DEFAULT_TIMEZONE}`, defaults to `Australia/Sydney`