# Nginx + Pagespeed + OpenSSL

Nginx 1.9.3
ngx_pagespeed 1.9.32.4
OpenSSL 1.0.1p

Built on 

## Nginx

Files are served from `/app/www/`

SSL configuration is stored in `/etc/nginx/ssl`

### Environment 

Nginx is configurable via environment variables, which are applied to the configuration on each service start, so you can adjust server parameters on the fly with, for example `export "UPLOAD_MAX_SIZE=10M"; sv restart nginx`

variable | value
-------- | -----
APP_USER | nginx
APP_GROUP | nginx
UPLOAD_MAX_SIZE | 30M
NGINX_MAX_WORKER_PROCESSES | 8

```bash
docker run -e "UPLOAD_MAX_SIZE=10M" funkygibbon/nginx-pagespeed
```

### Security

Nginx is compiled from source according to Ubuntu compile flags, and includes latest available OpenSSL sources

SSL is configured using modern sane defaults, including
- Mozilla's intermediate cipher string - see https://wiki.mozilla.org/Security/Server_Side_TLS
- SSLv2 and SSLv3 are disabled
- Automatic generation of a 2048bit DH parameter file if one is not provided
- Self-signed certificates generated on build, and stored in `/etc/nginx/ssl/default.key` `/etc/nginx/ssl/default.crt`.  Not recommended for front-facing live distributions, but adequate if behind an appropriate proxy.  To install your own certificates