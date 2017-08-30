FROM funkygibbon/nginx-php-exim

MAINTAINER Raymond Walker <hello@raywalker.it>

WORKDIR /app

RUN apt-get update && apt-get install -y git subversion && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV COMPOSER_HOME "/app/.composer"

ONBUILD ARG GIT_SOURCE="fnord"
ONBUILD ENV GIT_SOURCE ${GIT_SOURCE}
ONBUILD RUN /app/bin/add_user.sh && \
  mkdir -p "${COMPOSER_HOME}" && \
  git clone $GIT_SOURCE /app/source

ONBUILD WORKDIR /app/source

ONBUILD RUN chown -R "${APP_USER:-$DEFAULT_APP_USER}" "${COMPOSER_HOME}" /app/source && \
  composer install --no-interaction && \
  cp wp-cli.yml.default wp-cli.yml

ONBUILD RUN rm -fr /app/www && \
  ln -s /app/www /app/source/public \
