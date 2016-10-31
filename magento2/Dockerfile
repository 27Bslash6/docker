FROM funkygibbon/nginx-php-exim:7.0

COPY . /app/

RUN cp -R /app/etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/ && \
    cp -R /app/etc/my_init.d/* /etc/my_init.d/ && \
    apt-get update && \
    apt-get install sudo && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
    chmod +x /app/bin/install_composer.sh && \
    chmod +x /etc/my_init.d/*

RUN /app/bin/install_composer.sh