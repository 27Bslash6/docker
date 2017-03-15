FROM funkygibbon/nginx-php-exim:latest

COPY . /app/

RUN apt-get update && \
    apt-get install sudo && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN cp -R /app/etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/ && \
    cp -R /app/etc/my_init.d/* /etc/my_init.d/ && \
    chmod +x /app/bin/install_composer.sh && \
    chmod +x /etc/my_init.d/* && \
    cd /app && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    echo 'alias wp="sudo -u $APP_USER php /app/wp-cli.phar"' >> /root/.bashrc
