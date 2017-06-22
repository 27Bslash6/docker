# Varnish

Shameless copy of http://blog.benhall.me.uk/2015/01/scaling-wordpress-varnish-docker/

Adapted for funkygibbon/ubuntu


```yml
version: '2'
services:
  wordpress:
    image: funkygibbon/wordpress
  app:
    image: funkygibbon/varnish
    environment:
      - VIRTUAL_HOST=example.com
      - VARNISH_BACKEND_PORT=80
      - VARNISH_BACKEND_HOST=wordpress
```