#!/usr/bin/env bash

echo "Downloading incubator-pagespeed-ngx ${NGINX_PAGESPEED_VERSION} from https://github.com/apache/incubator-pagespeed-ngx/archive/${NGINX_PAGESPEED_VERSION}-${NGINX_PAGESPEED_RELEASE_STATUS}.tar.gz..."

wget -O - https://github.com/apache/incubator-pagespeed-ngx/archive/${NGINX_PAGESPEED_VERSION}-${NGINX_PAGESPEED_RELEASE_STATUS}.tar.gz --progress=bar --tries=3 \
	| tar zxf - -C /tmp

PSOL_URL=$(cat "/tmp/incubator-pagespeed-ngx-${NGINX_PAGESPEED_VERSION}-${NGINX_PAGESPEED_RELEASE_STATUS}/PSOL_BINARY_URL")

# The size names must match install/build_psol.sh in mod_pagespeed
if [ "$(uname -m)" = x86_64 ]; then
  PSOL_BIT_SIZE_NAME=x64
else
  PSOL_BIT_SIZE_NAME=ia32
fi

echo "Downloading incubator-pagespeed-ngx PSOL ${NGINX_PAGESPEED_VERSION} from ${PSOL_URL/\$BIT_SIZE_NAME/$PSOL_BIT_SIZE_NAME}..."

wget -O - ${PSOL_URL/\$BIT_SIZE_NAME/$PSOL_BIT_SIZE_NAME} --progress=bar --tries=3 \
	| tar zxf - -C /tmp/incubator-pagespeed-ngx-${NGINX_PAGESPEED_VERSION}-${NGINX_PAGESPEED_RELEASE_STATUS}/