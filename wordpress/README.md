# Wordpress

![PHP 7.3](https://img.shields.io/badge/php-7.3-brightgreen.svg) ![Nginx 1.17.4](https://img.shields.io/badge/nginx-1.17.4-brightgreen.svg) ![ngx_pagespeed latest-stable](https://img.shields.io/badge/ngx_pagespeed-latest--stable-brightgreen.svg) ![OpenSSL 1.1.0l](https://img.shields.io/badge/OpenSSL-1.1.0l-brightgreen.svg)

Wordpress-ready webserver stack built on [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)

Docker Hub: [funkygibbon/wordpress](https://hub.docker.com/r/funkygibbon/wordpress/)

---

`docker run -p "80:80" -p "443:443" -e "APP_HOSTNAME=some.example.com" -v /some/dir/www:/app/www funkygibbon/wordpress`

---

Included in this image:
- [wp-cli](http://wp-cli.org/), executes as `$APP_USER` and is preconfigured with --path="/app/www"
- [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed)
- [NewRelic](https://newrelic.com) PHP application monitoring - just add license
- exim4, ready for smarthost delivery to [sendgrid](https://sendgrid.net) or [mailgun](http://mailgun.net/)
- fully configurable cron daemon
- [xdebug](https://xdebug.org/) with configurable remote host/port/key
- Production / development environments, eg in development, all outgoing email is redirected to a configurable destination (`$ADMIN_EMAIL`) 
- Sane security defaults, and SSL configuration based on Mozilla's intermediate profile. See: [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/) for more details

---

This container is configurable via a plethora of environment variables, which are applied on boot and service start

var | default | description
--- | ------- | -----------
OVERWRITE_FILES | false | Set true to force install Wordpress and overwrite the contents of /app/www 
WP_TITLE | funkygibbon/wordpress | The title of the Wordpress install
WP_HOSTNAME |  | Wordpress URL. Tries to fallback to `$APP_HOSTNAME` if blank
WP_DB_HOST | mysql | Database hostname
WP_DB_NAME |  | Database name
WP_DB_USER |  | Database username
WP_DB_PASS |  | Database password
WP_DB_PREFIX | wordpress_ | Database table prefix
WP_PLUGINS | wordfence;debug-bar | semi-colon separated list of Wordpress plugins to install 
WP_ADMIN_NAME |  | Name of Wordpress administrator user to create
WP_ADMIN_USER |  | Username of Wordpress administrator user to create
WP_ADMIN_PASS |  | Password of Wordpress administrator user to create
WP_ADMIN_EMAIL |  | Email address of Wordpress administrator user to create
WP_VERSION | latest | Version of Wordpress to install
WP_LOCALE | en_AU | Locale of Wordpress to install
WP_THEME_HTTP |  | HTTP address of Wordpress theme to install
WP_THEME_GIT |  | Git address of Wordpress theme to install
WP_THEME_USERNAME |  | Username for theme install if authentication is required
WP_THEME_PASSWORD |  | Password for theme install if authentication is required
SSH_DOMAIN_HOSTKEYS |  | semi-colon separated list of additional SSH hostkeys to install for git/ssh theme.  github and bitbucket are pre-installed


See also features and configuration options from upstream images:
- [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)
- [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/)
- [funkygibbon/ubuntu](https://hub.docker.com/r/funkygibbon/ubuntu/)
