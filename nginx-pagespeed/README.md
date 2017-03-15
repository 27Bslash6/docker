# Nginx + Pagespeed + OpenSSL

![Nginx 1.11.10](https://img.shields.io/badge/nginx-1.11.10-brightgreen.svg) ![ngx_pagespeed latest-stable](https://img.shields.io/badge/ngx_pagespeed-latest--stable-brightgreen.svg) ![OpenSSL 1.0.2k](https://img.shields.io/badge/OpenSSL-1.0.2k-brightgreen.svg)


Built on [funkygibbon/ubuntu](https://registry.hub.docker.com/u/funkygibbon/ubuntu/), a lightly modified Ubuntu Xenial [Phusion Base Image](https://phusion.github.io/baseimage-docker/).


```bash
docker run -v "/path/to/www:/app/www" -p "80:80" -p "443:443" funkygibbon/nginx-pagespeed
```

Files are served from `/app/www/`, SSL certificates are generated in `/etc/nginx/ssl`, `/etc/nginx/sites-enabled/*` is searched for virtual hosts.

Nginx is configured with sane security defaults for out-of-the-box webservice, highly configurable by environment variables and is compiled from mainline source.

### Service configuration via ENV

Nginx is configurable via environment variables, which are re-applied to the configuration on service start, so you can adjust server parameters at container start with:

```bash
docker run -e "UPLOAD_MAX_SIZE=50M" funkygibbon/nginx-pagespeed
```

A minimal docker-compose.yml file:

```yml
version: '2'
services:
  app:
   image: funkygibbon/nginx-pagespeed
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /path/to/www:/app/www
```

##### Variables

variable | default | description
-------- | ------- | ---
APP_USER | nginx | Service user name
APP_GROUP | nginx | Service group name
UPLOAD_MAX_SIZE | 30M | Sets `nginx_client_max_body_size`
NGINX_MAX_WORKER_PROCESSES | 8 | Sets `worker_processes`, defaults to largest of eight, or the number available cores
CHOWN_APP_DIR | false | If true `chown` `/app/www` as `APP_USER:APP_GROUP`


### Security

Nginx is compiled from mainline source according to Ubuntu compile flags, with the following modifications:
- OpenSSL 1.0.2k sources - https://www.openssl.org/source/
- Google Pagespeed nginx module - https://github.com/pagespeed/ngx_pagespeed/releases
- headers-more nginx module - https://github.com/openresty/headers-more-nginx-module/tags
- `http_ssi_module` and `http_autoindex_module` disabled

HTTPS is configured using modern sane defaults, including
- Mozilla's intermediate profile - see https://wiki.mozilla.org/Security/Server_Side_TLS
- SSLv2 and SSLv3 are disabled, TLSv1 TLSv2 and TLSv3 are enabled
- Automatic generation of a 2048bit DH parameter file if one is not provided
- Self-signed SSL certificates are generated on first container start, and stored in `/etc/nginx/ssl/default.key` `/etc/nginx/ssl/default.crt`.  To install your own certificates I recommend bind-mounting `ssl` and `sites-enabled` folders.
- @todo LetsEncrypt!

### On service start

- nginx user is set to `${APP_USER:-$DEFAULT_APP_USER}` (default is nginx)
- creates user and group from `{APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP}`, some sanity checks for matching UID / GID in the event that user/group already exists
- if `${CHOWN_APP_DIR:-$DEFAULT_CHOWN_APP_DIR}` is true, `chown -R ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www`  (default false)
- `worker_processes` is set to the number of available processor cores and adjusts `/etc/nginx/nginx.conf` to match, up to a maximum number of cores `${NGINX_MAX_WORKER_PROCESSES:-$DEFAULT_MAX_WORKER_PROCESSES}`
- `client_max_body_size` is set to `${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}`
