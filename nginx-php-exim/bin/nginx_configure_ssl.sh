#!/usr/bin/env bash
set -e

if [[ "${SSL_ENABLED}" = "false" ]]; then
  # SSL disabled
  _good "$(printf "%-10s " "openresty:")" "SSL disabled"
else
  # SSL enabled
  _good "$(printf "%-10s " "openresty:")" "SSL enabled"

  if [[ ! -f "/etc/nginx/ssl/${APP_HOSTNAME}.dhparam.pem" ]]; then
    # Generate Diffie Hellman parameter file, as the default shipped with Ubuntu is 1024bits and considered insecure
    # https://wiki.mozilla.org/Security/Server_Side_TLS#DHE_handshake_and_dhparam
    _good "$(printf "%-10s " "openresty:")" "Generating /etc/nginx/ssl/${APP_HOSTNAME}.dhparam.pem ..."
    openssl dhparam -out "/etc/nginx/ssl/${APP_HOSTNAME}.dhparam.pem" 2048 >/dev/null 2>&1 &
  fi

  if [[ ! -f "/etc/nginx/ssl/${APP_HOSTNAME}.key" ]]; then
    # Generate a self signed certificate if one does not exist
    # Expires in 365 days
    _good "$(printf "%-10s " "openresty:")" "Generating default /etc/nginx/ssl/${APP_HOSTNAME}.key /etc/nginx/ssl/${APP_HOSTNAME}.crt"
    openssl req -x509 -newkey rsa:2048 -keyout "/etc/nginx/ssl/${APP_HOSTNAME}.key" -out "/etc/nginx/ssl/${APP_HOSTNAME}.crt" -nodes -days 365 -subj "/C=NL/ST=State/L=Location/O=Org/OU=OrgUnit/CN=localdomain" >/dev/null 2>&1 &
  fi

fi

wait
