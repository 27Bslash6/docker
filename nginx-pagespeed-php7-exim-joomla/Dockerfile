FROM fuww/nginx-pagespeed-php7-exim

RUN apt-get -y --no-install-recommends install \
		unzip && \
	apt-get clean

# VOLUME /app/www

# Please mind, Adding SSL will add a lot of startup time
ENV SSL_ENABLED false

# Define Joomla version and expected SHA1 signature
ENV JOOMLA_VERSION 3.6.2
ENV JOOMLA_SHA1 fdaa25337aaabd0d673aafc0ff90e7375de2d6e3

WORKDIR /app/www

# Download package and extract to web volume
RUN curl -o joomla.tar.gz -SL https://github.com/joomla/joomla-cms/releases/download/${JOOMLA_VERSION}/Joomla_${JOOMLA_VERSION}-Stable-Full_Package.tar.gz
# RUN	echo "$JOOMLA_SHA1 *joomla.tar.gz" | sha1sum -c -
RUN	tar -zxvf joomla.tar.gz
RUN	rm joomla.tar.gz

# && chown -R www-data:www-data /app/www

# Local MySQL, disable to use live configuration.php
COPY ./configuration-qa-with-testdb.php /app/www/configuration.php

RUN apt-get -y --no-install-recommends install nano

COPY .docker/etc /etc

CMD ["/sbin/my_init"]