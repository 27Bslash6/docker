FROM funkygibbon/ubuntu

EXPOSE 80
EXPOSE 443

# http://nginx.org/en/download.html
ENV NGINX_VERSION 1.22.1

# https://github.com/openresty/headers-more-nginx-module/tags
ENV HEADERS_MORE_VERSION 0.34

# https://www.openssl.org/source
ENV OPENSSL_VERSION 1.1.1s

RUN useradd -r -s /usr/sbin/nologin nginx && mkdir -p /var/log/nginx /var/cache/nginx
RUN	apt-get update && \
	apt-get -y install wget git-core perl libc6-dev autoconf automake libtool build-essential zlib1g-dev libpcre3-dev libxslt1-dev libxml2-dev libgeoip-dev libgoogle-perftools-dev libperl-dev && \
	echo "Downloading nginx v${NGINX_VERSION} from http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz ..." && wget -O - http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz --progress=bar --tries=3 | tar zxf - -C /tmp && \
    echo "Downloading headers-more v${HEADERS_MORE_VERSION} from https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz ..." && wget -O - https://github.com/openresty/headers-more-nginx-module/archive/v${HEADERS_MORE_VERSION}.tar.gz --progress=bar --tries=3 | tar zxf - -C /tmp && \
    echo "Downloading openssl v${OPENSSL_VERSION} from https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz ..." && wget -O - https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz --progress=bar --tries=3 | tar xzf  - -C /tmp && \
    cd /tmp/nginx-${NGINX_VERSION} && \
	./configure \
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
		--without-http_autoindex_module \
		--without-http_ssi_module \
		--with-threads  \
		--with-stream  \
		--with-stream_ssl_module  \
		--with-mail  \
		--with-mail_ssl_module  \
		--with-file-aio  \
		--with-http_v2_module \
		--with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2'  \
		--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,--as-needed' \
		--with-ipv6 \
		--with-pcre-jit \
		--with-openssl=/tmp/openssl-${OPENSSL_VERSION} \
		--add-module=/tmp/headers-more-nginx-module-${HEADERS_MORE_VERSION} && \
	make && \
	make install && \
	apt-get purge -yqq build-essential autoconf automake libtool git-core zlib1g-dev libpcre3-dev libxslt1-dev libxml2-dev libgeoip-dev libgoogle-perftools-dev libperl-dev && \
	apt-get autoremove -yqq && \
	apt-get clean && \
	rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ENV DEFAULT_APP_USER app
ENV DEFAULT_APP_GROUP app
ENV DEFAULT_APP_UID 1000
ENV DEFAULT_APP_GID 1000
ENV DEFAULT_UPLOAD_MAX_SIZE 30M
ENV DEFAULT_NGINX_MAX_WORKER_PROCESSES 8
ENV DEFAULT_CHOWN_APP_DIR true

ENV SSL_ENABLED true

COPY . /app/

RUN chmod 750 /app/bin/*.sh

RUN /app/bin/init_nginx.sh
