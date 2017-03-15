# Wordpress

![PHP 7.0](https://img.shields.io/badge/php-7.0-brightgreen.svg) ![Nginx 1.11.10](https://img.shields.io/badge/nginx-1.11.10-brightgreen.svg) ![ngx_pagespeed latest-stable](https://img.shields.io/badge/ngx_pagespeed-latest--stable-brightgreen.svg) ![OpenSSL 1.0.2k](https://img.shields.io/badge/OpenSSL-1.0.2k-brightgreen.svg)

Wordpress-ready webserver stack built on [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)

Docker Hub: [funkygibbon/wordpress](https://hub.docker.com/r/funkygibbon/wordpress/)

---

`docker run -p "80:80" -p "443:443" -e "APP_HOSTNAME=some.example.com" -v /some/dir/www:/app/www funkygibbon/wordpress`

---

Included in this image:
- [wp-cli](http://wp-cli.org/), automatically drops root to `$APP_USER` and is preconfigured with -path="/app/www"
- [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed)
- [NewRelic](https://newrelic.com) PHP application monitoring - just add license
- exim4, ready for smarthost delivery to [sendgrid](https://sendgrid.net) or [mailgun](http://mailgun.net/)
- fully configurable cron daemon
- [xdebug](https://xdebug.org/) with configurable remote host/port/key
- Production / development environments, eg in development, all outgoing email is redirected to a configurable destination (`$ADMIN_EMAIL`) 
- Sane security defaults, and SSL configuration based on Mozilla's intermediate profile. See: [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/) for more details

---

This container is configurable via a plethora of environment variables, which are applied on service start so you can generally reconfigure any aspect of the stack by executing `docker exec foo_bar_1 sv restart php|nginx`

var | default | description
--- | ------- | -----------
NEWRELIC_ENABLED | true | Enables or disables [Newrelic.com](https://newrelic.com/) reporting
NEWRELIC_APPNAME | $PHP_POOL_NAME | Application name in Newrelic APM list. Defaults to PHP pool name (APP_HOSTNAME with underscores instead of periods)   
NEWRELIC_LICENSE | \_\_DISABLED\_\_ | Newrelic account license key.  Available from your Newrelic account page


See also features and configuration options from upstream images:
- [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)
- [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/)
- [funkygibbon/ubuntu](https://hub.docker.com/r/funkygibbon/ubuntu/)
