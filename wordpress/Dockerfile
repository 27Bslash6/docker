FROM funkygibbon/nginx-php-exim:latest

COPY . /app/

WORKDIR /app

RUN cp -R etc/nginx/* /etc/nginx/ && \
    cp wp.sh /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

