#!/usr/bin/env bash
set -e

# Configure pagespeed to support downstream caching
# See: https://modpagespeed.com/doc/downstream-caching
# FIXME This is not implemented properly yet
_good "$(printf "%-10s " "openresty:")" "PAGESPEED_REBEACON_KEY ${PAGESPEED_REBEACON_KEY}"

dockerize -template /app/templates/etc/nginx/server.d/10_pagespeed.conf.tmpl:/etc/nginx/server.d/10_pagespeed.conf
