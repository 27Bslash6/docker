# funkygibbon/wordpress-stateless

WIP idempotent WordPress container which when completed will automatically install:
 - WordPress via wp-cli - latest or version-locked
 - All necessary plugins from wordpress.org or custom URLs
 - Themes from wordpress.org or custom URLs
 - Connects to media files using Google Storage Buckets / S3 / other CDN or NFS shares
  
 
Currently functional apart from fully integrating media file functionality.  That's a curly one, especially when trying to deal with custom template generated files, eg. from Gantry's gantry-media locator.
 
 All advice, suggestions, forks, pull requests gleefully appreciated.