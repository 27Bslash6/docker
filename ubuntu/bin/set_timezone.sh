#!/usr/bin/env bash

echo "${CONTAINER_TIMEZONE}" >/etc/timezone
ln -fs "/usr/share/zoneinfo/${CONTAINER_TIMEZONE}" /etc/localtime
dpkg-reconfigure tzdata
