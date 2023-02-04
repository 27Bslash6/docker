#!/usr/bin/env bash
set -e

if [[ -n "${APP_HOSTPATH}" ]]; then
  _good "$(printf "%-10s " "openresty:")" "APP_HOSTPATH=${APP_HOSTPATH}"
  dockerize \
    -template /app/templates/etc/nginx/server.d/00_rewrite_path.conf.tmpl:/etc/nginx/server.d/00_rewrite_path.conf
else
  rm -f /etc/nginx/server.d/00_rewrite_path.conf
fi
