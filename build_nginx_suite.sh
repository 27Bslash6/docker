#!/bin/bash

set -e

NAMESPACE=funkygibbon

TAG=latest

PROJECT_DIR=`pwd`

PROJECTS=("nginx" "nginx-pagespeed" "nginx-php-exim" "magento2" "nginx-proxy" "wordpress")

# http://nginx.org/en/download.html
NGINX_VERSION="1.11.10"

# https://github.com/pagespeed/ngx_pagespeed/releases
NGINX_PAGESPEED_VERSION="latest-stable"

NGINX_PSOL_VERSION="1.11.33.4"

# https://www.openssl.org/source
OPENSSL_VERSION="1.0.2k"

# https://github.com/openresty/headers-more-nginx-module/tags
HEADERS_MORE_VERSION="0.32"

PHP_VERSION="7.0"

SED_COMMAND="docker run --rm -v ${PROJECT_DIR}:/app busybox sed"
SED_TARGET_LOCATION="/app"

#
BUILD=1

while getopts "b:n:t:" opt; do
  case $opt in
  b)
      if [ "$OPTARG" == "true" ]
      then
        BUILD=1
      else
        BUILD=0
      fi
      ;;
  n)
      NAMESPACE=$OPTARG
      ;;
  t)
      TAG=$OPTARG
      ;;

  esac
done

shift $((OPTIND - 1))

for PROJECT in "${PROJECTS[@]}"
do
  echo -e "->> ${NAMESPACE}/${PROJECT}"

  if [ ! -d ${PROJECT_DIR}/${PROJECT} ]; then
    echo -e "ERROR :: Directory not found : ${PROJECT_DIR}/${PROJECT}"
    continue
  fi

  $SED_COMMAND -i -r \
    -e "s/ENV NGINX_VERSION .*/ENV NGINX_VERSION ${NGINX_VERSION}/g" \
    -e "s/ENV NGINX_PAGESPEED_VERSION .*/ENV NGINX_PAGESPEED_VERSION ${NGINX_PAGESPEED_VERSION}/g" \
    -e "s/ENV NGINX_PSOL_VERSION .*/ENV NGINX_PSOL_VERSION ${NGINX_PSOL_VERSION}/g" \
    -e "s/ENV OPENSSL_VERSION .*/ENV OPENSSL_VERSION ${OPENSSL_VERSION}/g" \
    -e "s/ENV HEADERS_MORE_VERSION .*/ENV HEADERS_MORE_VERSION ${HEADERS_MORE_VERSION}/g" \
    -e "s/ENV PHP_VERSION .*/ENV PHP_VERSION ${PHP_VERSION}/g" \
    ${SED_TARGET_LOCATION}/${PROJECT}/Dockerfile

  $SED_COMMAND -i -r \
    -e "s/(nginx)([ -])[0-9\.]+/\1\2${NGINX_VERSION}/ig" \
    -e "s/(ngx_pagespeed)([ -])[0-9\.]+/\1\2${NGINX_PAGESPEED_VERSION}/ig" \
    -e "s/ngx_pagespeed-latest-stable/ngx_pagespeed-latest--stable/ig" \
    -e "s/(openssl)([ -])[0-9a-z\.]+/\1\2${OPENSSL_VERSION}/ig" \
    -e "s/(php)([ -])[0-9\.]+/\1\2${PHP_VERSION}/ig" \
    ${SED_TARGET_LOCATION}/${PROJECT}/README.md

  if [ "$BUILD" -eq 1 ]; then
      echo -e "\nBuilding ${NAMESPACE}/${PROJECT}:${TAG} ...\n"
      docker build -t ${NAMESPACE}/${PROJECT}:${TAG} ${PROJECT_DIR}/${PROJECT}
  fi

done
