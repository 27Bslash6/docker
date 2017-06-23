# Varnish




```yml
version: '2'
services:
  wordpress:
    image: funkygibbon/wordpress
  app:
    image: funkygibbon/varnish
    environment:
      - VIRTUAL_HOST=example.com
      - VARNISH_BACKEND_HOSTNAME=example.com
      - VARNISH_BACKEND_ADDRESS=wordpress
```