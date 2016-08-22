# Build the App server

fuww/nginx-pagespeed-php7-exim-joomla

docker build -t fuww/nginx-pagespeed-php7-exim-joomla:latest . && \
docker run -p "80:80" -e "SSL_ENABLED=false" fuww/nginx-pagespeed-php7-exim-joomla

docker-compose up

docker tag -f fuww/nginx-pagespeed-php7-exim:latest fuww/nginx-pagespeed-php7-exim:latest && \
docker push fuww/nginx-pagespeed-php7-exim:latest