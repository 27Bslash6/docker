backend default {
  .host = "{VARNISH_BACKEND_HOST}";
  .port = "{VARNISH_BACKEND_PORT}";
}

sub vcl_recv {
  if (req.request == "PURGE") {
    return(lookup);
  }
  if (req.url ~ "^/$") {
    unset req.http.cookie;
  }
}

sub vcl_hit {
  if (req.request == "PURGE") {
    set obj.ttl = 0s;
    error 200 "Purged.";
  }
}

sub vcl_miss {
  #if purge request was not found, send 404 error
  if (req.request == "PURGE") {
    error 404 "Not in cache.";
  }
  #if request was not meant for the Wordpress admin interface, unset cookies
  if (!(req.url ~ "wp-(login|admin)")) {
    unset req.http.cookie;
  }
  #remove cookies from static resources
  if (req.url ~ "^/[^?]+.(jpeg|jpg|png|gif|ico|js|css|txt|gz|zip|lzma|bz2|tgz|tbz|html|htm)(\?.|)$") {
    unset req.http.cookie;
    set req.url = regsub(req.url, "\?.$", "");
  }
  if (req.url ~ "^/$") {
    unset req.http.cookie;
  }
}

sub vcl_fetch {
  set beresp.ttl = 1w;

  if (req.url ~ "^/$") {
    unset beresp.http.set-cookie;
  }

  #bypass the proxy if the url contains the admin, login, preview or the xmlrpc
  if (req.url ~ "wp-(login|admin)" || req.url ~ "preview=true" || req.url ~ "xmlrpc.php") {
    return (hit_for_pass);
  }

  if (!(req.url ~ "wp-(login|admin)")) {
    unset beresp.http.set-cookie;
  }
}

