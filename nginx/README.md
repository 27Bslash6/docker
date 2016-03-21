# Nginx + OpenSSL

![Nginx 1.9.10](https://img.shields.io/badge/nginx-1.9.10-brightgreen.svg) ![OpenSSL 1.0.1s](https://img.shields.io/badge/OpenSSL-1.0.1s-brightgreen.svg)

Built on [funkygibbon/ubuntu](https://registry.hub.docker.com/u/funkygibbon/ubuntu/), a lightly modified [Phusion Base Image](https://phusion.github.io/baseimage-docker/)

## TLDR;

```bash
docker run -v "/path/to/www:/app/www" -p "80:80" -p "443:443" funkygibbon/nginx
```

Nginx is compiled from mainline source, if you would like to build the stable version, clone this repository and edit the `NGINX_VERSION` number to suit.

Files are served from `/app/www/`

SSL configuration is stored in `/etc/nginx/ssl`

Nginx reads `/etc/nginx/sites-enabled` for its virtual hosts, and comes with some sane defaults for out-of-the-box webserving.

### Environment 

Nginx is configurable via environment variables, which are applied to the configuration on each service start, so you can adjust server parameters on the fly with, for example:

```bash
docker exec -ti <nginx> export "UPLOAD_MAX_SIZE=10M"; sv restart nginx
```

variable | value
-------- | -----
APP_USER | nginx
APP_GROUP | nginx
UPLOAD_MAX_SIZE | 30M
NGINX_MAX_WORKER_PROCESSES | 8
CHOWN_APP_DIR | true

```bash
docker run -e "UPLOAD_MAX_SIZE=10M" funkygibbon/nginx-pagespeed
```

### On service start

- nginx user is set to `${APP_USER:-$DEFAULT_APP_USER}` (default is nginx)
- creates user and group from `{APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP}`, some sanity checks for matching UID / GID in the event that user/group already exists
- if `${CHOWN_APP_DIR:-$DEFAULT_CHOWN_APP_DIR}` is true, `chown -R ${APP_USER:-$DEFAULT_APP_USER}:${APP_GROUP:-$DEFAULT_APP_GROUP} /app/www`  (default true)
- `worker_processes` is set to the number of available processor cores and adjusts `/etc/nginx/nginx.conf` to match, up to a maximum number of cores `${NGINX_MAX_WORKER_PROCESSES:-$DEFAULT_MAX_WORKER_PROCESSES}`
- `client_max_body_size` is set to `${UPLOAD_MAX_SIZE:-$DEFAULT_UPLOAD_MAX_SIZE}`

### Security

Nginx is compiled from mainline source according to Ubuntu compile flags, with the following modifcations:
- includes latest OpenSSL 1.0.1 sources - https://www.openssl.org/source/
- includes headers-more module to enable removal of sensitive headers such as X-Powered-By
- includes Google Brotli compression module
- `http_ssi_module` and `http_autoindex_module` disabled

HTTPS is configured using modern sane defaults, including
- Mozilla's intermediate profile - see https://wiki.mozilla.org/Security/Server_Side_TLS
- SSLv2 and SSLv3 are disabled, TLSv1 TLSv2 and TLSv3 are enabled
- Automatic generation of a 2048bit DH parameter file if one is not provided
- Self-signed SSL certificates are generated on first container start, and stored in `/etc/nginx/ssl/default.key` `/etc/nginx/ssl/default.crt`.  To install your own certificates I recommend creating an `ssl` and `sites-enabled` folder and mounting these folders as volumes, alongside your `www` volume.

Nginx changelog: http://nginx.org/en/CHANGES

### Docker Compose

An example docker-compose.yml file:

```yml
app:
  image: funkygibbon/nginx-pagespeed
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - /path/to/www:/app/www
    - /path/to/ssl:/etc/nginx/ssl
    - /path/to/sites-enabled:/etc/nginx/sites-enabled
  environment:
    - UPLOAD_MAX_SIZE=100M

```