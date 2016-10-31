#!/bin/bash

set -e

NAMESPACE=funkygibbon

TAG=latest

PROJECT_DIR=`pwd`

PROJECTS=("nginx" "nginx-pagespeed" "nginx-php-exim" "nginx-proxy" )

NGINX_VERSION="1.11.5"

NGINX_PAGESPEED_VERSION="latest-stable"

NGINX_PSOL_VERSION="1.11.33.4"

OPENSSL_VERSION="1.0.2j"

HEADERS_MORE_VERSION="0.31"

while getopts n:t: opt; do
  case $opt in
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

  if [ ! -d ${PROJECT_DIR}/${PROJECT} ]; then
    echo -e "ERROR :: Directory not found : ${PROJECT_DIR}/${PROJECT}"
    continue
  fi

  cd ${PROJECT_DIR}/${PROJECT}

  sed -i -r "s/ENV NGINX_VERSION .*/ENV NGINX_VERSION ${NGINX_VERSION}/g" Dockerfile
  sed -i -r "s/ENV NGINX_PAGESPEED_VERSION .*/ENV NGINX_PAGESPEED_VERSION ${NGINX_PAGESPEED_VERSION}/g" Dockerfile
  sed -i -r "s/ENV NGINX_PSOL_VERSION .*/ENV NGINX_PSOL_VERSION ${NGINX_PSOL_VERSION}/g" Dockerfile
  sed -i -r "s/ENV OPENSSL_VERSION .*/ENV OPENSSL_VERSION ${OPENSSL_VERSION}/g" Dockerfile
  sed -i -r "s/ENV HEADERS_MORE_VERSION .*/ENV HEADERS_MORE_VERSION ${HEADERS_MORE_VERSION}/g" Dockerfile

  sed -i -r "s/(nginx)([ -])[0-9\.]+/\1\2${NGINX_VERSION}/ig" README.md
  sed -i -r "s/(ngx_pagespeed)([ -])[0-9\.]+/\1\2${NGINX_PAGESPEED_VERSION}/ig" README.md
  sed -i -r "s/(openssl)([ -])[0-9a-z\.]+/\1\2${OPENSSL_VERSION}/ig" README.md

  echo -e "Building ${NAMESPACE}/${PROJECT}:${TAG} ..."
  docker build -t ${NAMESPACE}/${PROJECT}:${TAG} .

done
