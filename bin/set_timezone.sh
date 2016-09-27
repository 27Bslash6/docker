#!/bin/sh

echo ${TIMEZONE:-$DEFAULT_TIMEZONE} > /etc/timezone && dpkg-reconfigure tzdata
