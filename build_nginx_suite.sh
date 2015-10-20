#!/bin/bash

set -e

NAMESPACE=funkygibbon

PROJECT_DIR=`pwd`

PROJECTS=("nginx" "nginx-pagespeed" "nginx-php-exim" "nginx-proxy" )

cd ${PROJECT_DIR}/nginx

for i in "${PROJECTS[@]}"
do
  cd ${PROJECT_DIR}/${i}
  echo -e "Building ${NAMESPACE}/${i} ..."
  docker build -t ${NAMESPACE}/${i} .

done
