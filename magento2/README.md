# Magento 2 Webserver stack

![PHP 7.0](https://img.shields.io/badge/php-7.0-brightgreen.svg) ![Nginx 1.13.3](https://img.shields.io/badge/nginx-1.13.3-brightgreen.svg) ![ngx_pagespeed latest-stable](https://img.shields.io/badge/ngx_pagespeed-latest--stable-brightgreen.svg) ![OpenSSL 1.1.0f](https://img.shields.io/badge/OpenSSL-1.1.0f-brightgreen.svg)

Highly configurable Magento 2.1 stack built on [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)

Docker Hub: [funkygibbon/magento2](https://hub.docker.com/r/funkygibbon/magento2/)

Mount Magento root to `/app/source/public` and certificates to `/etc/nginx/ssl`

Example minimal docker-compose.yml

```yaml
version: "2"
services:
  app:
    image: funkygibbon/magento2
    volumes:
      - ./ssl:/etc/nginx/ssl
      - ./magento:/app/source/public
```

Includes ngx_pagespeed, cron tasks, latest composer, sudo for manipulating files as the correct user and vaguely sane security defaults

Use provided `magento` alias for command-line configuration changes, which expands to `sudo -u ${APP_USER:-$DEFAULT_APP_USER} /usr/bin/php /app/source/public/bin/magento"` and helps prevent operations such as `magento cache:flush` from writing files as root

Refer to [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/) and [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/) for many environment variables which affect container startup configuration.

More documentation to follow.
