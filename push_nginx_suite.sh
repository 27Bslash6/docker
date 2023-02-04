#!/bin/bash

set -e

NAMESPACE=${BUILD_NAMESPACE:-"funkygibbon"}

TAG=${BUILD_TAG:-$(date +'%Y%m%d')}


PROJECTS=("nginx-pagespeed" "nginx-php-exim")

#git submodule update --init

# source externals/ubuntu/bin/colours.sh

# Toggle building images,
# If set to 0 only updates variables in version numbers
BUILD=${BUILD_DO_BUILD:-"1"}


for PROJECT in "${PROJECTS[@]}"; do
  echo -e "->> ${NAMESPACE}/${PROJECT}"

  docker tag ${NAMESPACE}/${PROJECT}:latest ${NAMESPACE}/${PROJECT}:${TAG}
  docker push ${NAMESPACE}/${PROJECT}:${TAG}
done
