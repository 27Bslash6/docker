FROM funkygibbon/nginx-php-exim

COPY . /app/

RUN apt-get update && \
    apt-get install sudo && \
    apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN cp -R /app/etc/nginx/sites-enabled/* /etc/nginx/sites-enabled/ && \
    cp -R /app/etc/my_init.d/* /etc/my_init.d/ && \
    chmod +x /app/bin/install_composer.sh && \
    chmod +x /etc/my_init.d/* && \
    echo 'alias magento="sudo -u ${APP_USER:-$DEFAULT_APP_USER} /usr/bin/php /app/source/public/bin/magento"' >> /root/.bashrc

RUN /app/bin/install_composer.sh