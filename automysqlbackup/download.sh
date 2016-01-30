#!/usr/bin/env bash

if [[ "AUTOMYSQLBACKUP_VERSION" = "latest" ]]; then
    wget -q http://sourceforge.net/projects/automysqlbackup/files/latest/download -O /tmp/automysqlbackup.tar.gz
else
    echo "Not implemented"
fi

tar zxvf /tmp/automysqlbackup