FROM funkygibbon/docker-ubuntu-base

# RUN apt-get update && \
# 	apt-get install -y wget && \
# 	wget -q http://nginx.org/keys/nginx_signing.key -O- | sudo apt-key add - && \
# 	echo deb http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
# 	echo deb-src http://nginx.org/packages/mainline/ubuntu/ trusty nginx >> /etc/apt/sources.list && \
# 	apt-get update && \
# 	apt-get -y install nginx && \
# 	apt-get clean

EXPOSE 80
EXPOSE 443

ENV PAGESPEED_VERSION 1.9.32.4
ENV NGINX_VERSION 1.9.3

ENV OPENSSL_VERSION 1.0.1p

COPY sources.list /etc/apt/sources.list

RUN useradd -r -s /usr/sbin/nologin nginx && mkdir -p /var/log/nginx /var/cache/nginx && \
	apt-get update && \
	apt-get -y install wget build-essential zlib1g-dev libpcre3-dev libssl-dev libxslt1-dev libxml2-dev libgd2-xpm-dev libgeoip-dev libgoogle-perftools-dev libperl-dev && \
	wget -qO - https://github.com/pagespeed/ngx_pagespeed/archive/v${PAGESPEED_VERSION}-beta.tar.gz | tar zxf - -C /tmp && \
	wget -qO - http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar zxf - -C /tmp && \
	wget -qO - https://dl.google.com/dl/page-speed/psol/${PAGESPEED_VERSION}.tar.gz | tar xzf  - -C /tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta && \
	# Compile nginx with pagespeed module according to Ubuntu specific preset
	cd /tmp/nginx-${NGINX_VERSION} && ./configure \
		--prefix=/etc/nginx  \
		--sbin-path=/usr/sbin/nginx  \
		--conf-path=/etc/nginx/nginx.conf  \
		--error-log-path=/var/log/nginx/error.log \
		--http-log-path=/var/log/nginx/access.log \
		--pid-path=/var/run/nginx.pid \
		--lock-path=/var/run/nginx.lock \
		--http-client-body-temp-path=/var/cache/nginx/client_temp \
		--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
		--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp  \
		--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp  \
		--http-scgi-temp-path=/var/cache/nginx/scgi_temp  \
		--user=nginx  \
		--group=nginx  \
		--with-http_ssl_module  \
		--with-http_realip_module  \
		--with-http_addition_module  \
		--with-http_sub_module  \
		--with-http_dav_module  \
		--with-http_flv_module  \
		--with-http_mp4_module  \
		--with-http_gunzip_module  \
		--with-http_gzip_static_module  \
		--with-http_random_index_module  \
		--with-http_secure_link_module \
		--with-http_stub_status_module  \
		--with-http_auth_request_module  \
		--with-threads  \
		--with-stream  \
		--with-stream_ssl_module  \
		--with-mail  \
		--with-mail_ssl_module  \
		--with-file-aio  \
		--with-http_spdy_module  \
		--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'  \
		--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
		--with-ipv6 \
		--with-pcre-jit \
		--add-module=/tmp/ngx_pagespeed-${PAGESPEED_VERSION}-beta && make && make install && \
	rm -Rf /tmp/* && \
	apt-get purge -yqq wget build-essential && \
	apt-get autoremove -yqq && \
	apt-get clean

COPY . /

RUN chmod 750 /etc/service/nginx/run /boot.sh /init_nginx.sh
RUN /init_nginx.sh

ENTRYPOINT ["/boot.sh"]

CMD ["/sbin/my_init"]

