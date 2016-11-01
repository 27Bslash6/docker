# Magento 2 Webserver stack

![PHP 7.0](https://img.shields.io/badge/php-7.0-brightgreen.svg) ![Nginx 1.11.5](https://img.shields.io/badge/nginx-1.11.5-brightgreen.svg) ![ngx_pagespeed latest-stable](https://img.shields.io/badge/ngx_pagespeed-latest--stable-brightgreen.svg) ![OpenSSL 1.0.2j](https://img.shields.io/badge/OpenSSL-1.0.2j-brightgreen.svg)

Highly configurable Magento 2.1 stack built on [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)

Docker Hub: [funkygibbon/magento2](https://hub.docker.com/r/funkygibbon/magento2/)

Mount Magento root to `/app/www` and certificates to `/etc/nginx/ssl`

Example docker-compose.yml

```yaml
version: '2'
services:
  app:
    image: funkygibbon/magento2
    hostname: shop
    domainname: example.com
    extra_hosts:
     - "mysql:192.168.1.2"
    volumes:
     - ./ssl:/etc/nginx/ssl
     - ./magento:/app/www
    networks:
     - default
    depends_on:
     - redis
  redis:
    image: redis
    networks:
      - default
    volumes:
      - ./redis/data:/data

```

Includes cron tasks and latest composer 


More documentation to follow.