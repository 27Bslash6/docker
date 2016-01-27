# Nginx + PHP5-FPM + Exim

Webserver stack built on top of  [funkygibbon/nginx-pagespeed](https://registry.hub.docker.com/u/funkygibbon/nginx-pagespeed/), which is built on a [lightly modified Phusion Ubuntu base image](https://registry.hub.docker.com/u/funkygibbon/docker-ubuntu-base/)

Configurable via a plethora of environment variables, which are applied either on each boot or on service start

var | default | description
--- | ------- | -----------
APP_ENV | production | production, development :: 'development' enables http://www.xdebug.org/
ADMIN_EMAIL | nobody@example.com | Server administrator email, used for intercepted email in `development` mode
CHOWN_APP_DIR | true | if true, `chown $APP_USER:$APP_GROUP /app/www`
APP_HOSTNAME |  |  hostname of application, used to 
VIRTUAL_HOST | example.com | virtualhosts which this service should respond to, separated by commmas.  Useful for operating behind [jwilder/nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/).
TIMEZONE | Australia/Sydney | Server timezone
APP_USER | nginx-php | nginx and php5-fpm user 
APP_GROUP | nginx-php | nginx and php5-fpm group
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
EXIM_DELIVERY_MODE | local | smarthost, local :: set to smarthost to enable third party SMTP
PHP_XDEBUG_REMOTE_HOST | 172.17.42.1 | If $APP_ENV is `development`, XDebug is enabled and configured to communicate to this remote host
PHP_XDEBUG_REMOTE_PORT | 9000 | XDebug port
PHP_XDEBUG_IDE_KEY | default_ide_key | XDebug IDE Key
EXIM_MAIL_FROM | example.com | domain from which exim4 mail appears to originate
EXIM_SMARTHOST | smtp.example.org::587 | smarthost relay
EXIM_SMARTHOST_AUTH_USERNAME | postmaster@example.com | smarthost auth
EXIM_SMARTHOST_AUTH_PASSWORD | password_123 | smarthost password