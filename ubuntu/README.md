# funkygibbon/ubuntu

Automated daily build of an Ubuntu Xenial base image from phusion/baseimage (https://github.com/phusion/baseimage-docker/releases/tag/focal-1.2.0).

- Adds Jason Wilder's handy [Dockerize](https://github.com/jwilder/dockerize) binary
- Defines structures for source environment files (`/app/env/`), copying `/app/etc` to `/etc`
- Container timezone is set via environment variable `CONTAINER_TIMEZONE`, defaults to `etc/UTC`
