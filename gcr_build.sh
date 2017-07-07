#!/usr/bin/env bash

TMPDIR=$(mktemp -d "${TMPDIR:-/tmp/}$(basename 0).XXXXXXXXXXXX")

tar --exclude='.git/' -zcvf $TMPDIR/docker-source.tar.gz .

time gcloud container builds submit --timeout=30m --config cloudbuild.yaml $TMPDIR/docker-source.tar.gz && rm -fr $TMPDIR
