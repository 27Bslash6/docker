#!/bin/bash

set -e

NAMESPACE=funkygibbon

TAG=latest

PROJECT_DIR=`pwd`

PROJECTS=("nginx" "nginx-pagespeed" "nginx-php-exim" "nginx-proxy" )

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
  echo -e "Building ${NAMESPACE}/${PROJECT}:${TAG} ..."
  docker build -t ${NAMESPACE}/${PROJECT}:${TAG} .

done
