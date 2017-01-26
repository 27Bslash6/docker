# Nginx + PHP + Exim

![PHP 7.0](https://img.shields.io/badge/php-7.0-brightgreen.svg) ![Nginx 1.11.9](https://img.shields.io/badge/nginx-1.11.9-brightgreen.svg) ![ngx_pagespeed latest-stable](https://img.shields.io/badge/ngx_pagespeed-latest--stable-brightgreen.svg) ![OpenSSL 1.0.2j](https://img.shields.io/badge/OpenSSL-1.0.2j-brightgreen.svg)

Highly configurable nginx-PHP webserver stack built on [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/), which is in turn built on a [lightly modified Phusion Ubuntu base image](https://hub.docker.com/r/funkygibbon/ubuntu/)

Docker Hub: [funkygibbon/nginx-php-exim](https://hub.docker.com/r/funkygibbon/nginx-php-exim/)

---

`docker run -p "80:80" -p "443:443" -e "APP_HOSTNAME=some.example.com" -v /some/dir/www:/app/www funkygibbon/nginx-php-exim`

---

Included in this image:
- [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed)
- [NewRelic PHP monitoring](https://newrelic.com)
- exim4, ready for smarthost delivery to [sendgrid](https://sendgrid.net) or [mailgun](http://mailgun.net/)
- fully functional cron daemon
- [xdebug](https://xdebug.org/) with configurable remote host/port/key
- Production / development environments.  All outgoing email is redirected to a configurable destination (`$ADMIN_EMAIL`)in development
- Sane security defaults, and SSL confugration based on Mozilla's intermediate profile. See: [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/) for details

---

This container is configurable via a plethora of environment variables, which are applied on service start so you can generally reconfigure any aspect of the stack by executing `docker exec foo_bar_1 sv restart php|nginx`

var | default | description
--- | ------- | -----------
APP_ENV | production | production, development :: 'development' enables http://www.xdebug.org/
ADMIN_EMAIL | nobody@example.com | Server administrator email, used for intercepted email in `development` mode
CHOWN_APP_DIR | true | if true, `chown -R $APP_USER:$APP_GROUP /app/www`
APP_HOSTNAME | `hostname -f` |  hostname of application 
VIRTUAL_HOST | example.com | virtualhosts which this service should respond to, separated by commmas.  Useful for operating behind [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/).
CONTAINER_TIMEZONE | Australia/Sydney | Server timezone
APP_USER | app | nginx and php5-fpm user 
APP_GROUP | app | nginx and php5-fpm group
APP_UID | 1000 | user_id - useful when mounting volumes from host > guest to either share or delineate file access permission
APP_GID | 1000 | group_id
UPLOAD_MAX_SIZE | 30M | Maximum upload size, applied to nginx and php5-fpm
NGINX_MAX_WORKER_PROCESSES | 8 | nginx worker_processes is determined from number of processor cores on service start, up to the maximum permitted by NGINX_MAX_WORKER_PROCESSES
PHP_MEMORY_LIMIT | 128M | Maximum memory PHP can use per worker
PHP_PROCESS_MANAGER | dynamic | dynamic, static, ondemand :: PHP process manager scheme
PHP_MAX_CHILDREN | 6 | process manager maximum spawned children 
PHP_START_SERVERS | 3 | if PHP_PROCESS_MANAGER is dynamic, this is the number of children spawned on boot
PHP_MIN_SPARE_SERVERS | 2 | if PHP_PROCESS_MANAGER is dynamic, this is the minimum number of idle children 
PHP_MAX_SPARE_SERVERS | 3 | if PHP_PROCESS_MANAGER is dynamic, this is the maximum number of idle children
PHP_MAX_REQUESTS | 500 | Maximum number of requests each child process can process before terminating, which should mitigate any memory leaks. Set to 0 to disable.
PHP_DISABLE_FUNCTIONS | false | Comma separated list of additional functions to disable for security.  These are appended to the default Ubuntu distribution disable_functions line 
PHP_XDEBUG_REMOTE_HOST | 172.17.42.1 | If $APP_ENV is `development`, XDebug is enabled and configured to communicate to this remote host
PHP_XDEBUG_REMOTE_PORT | 9000 | XDebug port
PHP_XDEBUG_IDE_KEY | default_ide_key | XDebug IDE Key
EXIM_DELIVERY_MODE | local | smarthost, local :: set to smarthost to enable third party SMTP
EXIM_MAIL_FROM | example.com | domain from which exim4 mail appears to originate
EXIM_SMARTHOST | smtp.example.org::587 | smarthost relay SMTP server address and port (note the double colon (::) before port number)
EXIM_SMARTHOST_AUTH_USERNAME | postmaster@example.com | SMTP username
EXIM_SMARTHOST_AUTH_PASSWORD | password_123 | SMTP password
NEWRELIC_ENABLED | true | Enables or disables [Newrelic.com](https://newrelic.com/) reporting
NEWRELIC_APPNAME | $PHP_POOL_NAME | Application name in Newrelic APM list. Defaults to PHP pool name (APP_HOSTNAME with underscores instead of periods)   
NEWRELIC_LICENSE | \_\_DISABLED\_\_ | Newrelic account license key.  Available from your Newrelic account page

See also configuration options from upstream images:
- [funkygibbon/nginx-pagespeed](https://hub.docker.com/r/funkygibbon/nginx-pagespeed/)
- [funkygibbon/ubuntu](https://hub.docker.com/r/funkygibbon/ubuntu/)

---

### Philosophy

I understand a degree of pushback against the idea of bundling so much into one container, at first glance it seems 'against the Docker microservice philosophy'.

However, in my experience, so much is gained by bundling these items together - nginx and php have similar configuration options which require tweaking synchronously - think nginx `UPLOAD_MAX_SIZE`, php `UPLOAD_MAX_FILESIZE` and `POST_MAX_SIZE`, file and socket permissions, performance improvement in communication over socket vs tcp.

I am prepared to be convinced that this is totally utterly wrong-headed, and may consider breaking this PHP installation out to separate nginx/PHP containers if there's a need, but for now, it just works for me.