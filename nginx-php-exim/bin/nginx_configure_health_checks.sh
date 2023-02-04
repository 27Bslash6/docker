#!/bin/bash
set -euo pipefail

# Configure health checks

f=/etc/nginx/server.d/40_health-check.conf

dockerize -template "/app/templates$f.tmpl:$f"
