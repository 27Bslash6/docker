# Build the App server

fuww/nginx-pagespeed-php7-exim-joomla

docker build -t fuww/nginx-pagespeed-php7-exim-joomla:latest . && \
docker run -p "80:80" -e "SSL_ENABLED=false" fuww/nginx-pagespeed-php7-exim-joomla:latest

docker-compose up

docker tag fuww/nginx-pagespeed-php7-exim-joomla:latest fuww/nginx-pagespeed-php7-exim-joomla:latest && \
docker push fuww/nginx-pagespeed-php7-exim-joomla:latest