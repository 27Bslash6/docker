#!/bin/bash

set -e

NAMESPACE=${BUILD_NAMESPACE:-"funkygibbon"}

TAG=${BUILD_TAG:-"latest"}

# http://nginx.org/en/download.html
NGINX_VERSION=${BUILD_NGINX_VERSION:-"1.22.1"}

# https://github.com/pagespeed/ngx_pagespeed/releases
NGINX_PAGESPEED_VERSION=${BUILD_PAGESPEED_VERSION:-"latest"}
NGINX_PAGESPEED_RELEASE_STATUS=${BUILD_PAGESPEED_RELEASE_STATUS:-"stable"}

# https://www.openssl.org/source
OPENSSL_VERSION=${BUILD_OPENSSL_VERSION:-"1.1.1s"}

# https://github.com/openresty/headers-more-nginx-module/tags
HEADERS_MORE_VERSION=${BUILD_HEADERS_MORE_VERSION:-"0.34"}

PHP_VERSION=${BUILD_PHP_VERSION:-"8.2"}

PROJECTS=("nginx-pagespeed" "nginx-php-exim" "wordpress" "nginx")

#git submodule update --init

# source externals/ubuntu/bin/colours.sh

# Toggle building images,
# If set to 0 only updates variables in version numbers
BUILD=${BUILD_DO_BUILD:-"1"}

while getopts "b:n:t:" opt; do
  case $opt in
  b)
    if [ "$OPTARG" == "true" ]; then
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
  shift $((OPTIND - 1))
done

for PROJECT in "${PROJECTS[@]}"; do
  echo -e "->> ${NAMESPACE}/${PROJECT}"

  ROOT_DIR=$(pwd)
  if [ -d ${ROOT_DIR}/${PROJECT} ]; then
    PROJECT_DIR=$ROOT_DIR
  elif [ -d ${ROOT_DIR}/externals/${PROJECT} ]; then
    PROJECT_DIR=${ROOT_DIR}/externals
  else
    #    _warning "ERROR :: Directory not found for: ${NAMESPACE}/${PROJECT}"
    echo -e "ERROR :: Directory not found for: ${NAMESPACE}/${PROJECT}"
    continue
  fi

  if type docker >/dev/null 2>&1; then
    SED_COMMAND="docker run --rm -v ${PROJECT_DIR}:/app busybox sed"
    SED_TARGET_LOCATION="/app"
  else
    SED_COMMAND="sed"
    SED_TARGET_LOCATION="."
  fi

  if [ ! -e ${PROJECT_DIR}/${PROJECT}/Dockerfile ]; then
    echo -e "File does not exist: ${SED_TARGET_LOCATION}/${PROJECT}/Dockerfile"
    continue
  fi

  $SED_COMMAND -i -r \
    -e "s/ENV NGINX_VERSION .*/ENV NGINX_VERSION ${NGINX_VERSION}/g" \
    -e "s/ENV NGINX_PAGESPEED_VERSION .*/ENV NGINX_PAGESPEED_VERSION ${NGINX_PAGESPEED_VERSION}/g" \
    -e "s/ENV NGINX_PAGESPEED_RELEASE_STATUS .*/ENV NGINX_PAGESPEED_RELEASE_STATUS ${NGINX_PAGESPEED_RELEASE_STATUS}/g" \
    -e "s/ENV OPENSSL_VERSION .*/ENV OPENSSL_VERSION ${OPENSSL_VERSION}/g" \
    -e "s/ENV HEADERS_MORE_VERSION .*/ENV HEADERS_MORE_VERSION ${HEADERS_MORE_VERSION}/g" \
    -e "s/ENV PHP_VERSION .*/ENV PHP_VERSION ${PHP_VERSION}/g" \
    ${SED_TARGET_LOCATION}/${PROJECT}/Dockerfile

  $SED_COMMAND -i -r \
    -e "s/(nginx)([ -])[0-9\.]+/\1\2${NGINX_VERSION}/ig" \
    -e "s/(ngx_pagespeed)([ -])[0-9\.]+/\1\2${NGINX_PAGESPEED_VERSION}/ig" \
    -e "s/ngx_pagespeed-latest-${NGINX_PAGESPEED_RELEASE_STATUS}/ngx_pagespeed-latest--${NGINX_PAGESPEED_RELEASE_STATUS}/ig" \
    -e "s/(openssl)([ -])[0-9a-z\.]+/\1\2${OPENSSL_VERSION}/ig" \
    -e "s/(php)([ -])[0-9\.]+/\1\2${PHP_VERSION}/ig" \
    ${SED_TARGET_LOCATION}/${PROJECT}/README.md

  if [ "$BUILD" -eq 1 ]; then
    echo -e "\nBuilding ${NAMESPACE}/${PROJECT}:${TAG} ...\n"
    docker build -t ${NAMESPACE}/${PROJECT}:${TAG} ${PROJECT_DIR}/${PROJECT}
  fi

done
