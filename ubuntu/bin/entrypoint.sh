#!/usr/bin/env bash
# shellcheck disable=1090
set -euo pipefail

chmod +x /app/bin/*

# Configure environment
for env_file in /app/env/*; do
  . "${env_file}"
done

# Ensure service start scripts are executable
[[ -d /app/etc/service ]] && find /app/etc/service -type f -name 'run' -exec chmod 755 {} \;

# Add application user
[[ -x /app/bin/add_user.sh ]] && /app/bin/add_user.sh

# Install configuration overrides
[[ -d /app/etc ]] && rsync -aK /app/etc/* /etc/

[[ -d /etc/my_init.d ]] && chmod 755 /etc/my_init.d/*.sh

# =============================================================================
# 	BOOT
# =============================================================================

# _good "$(date) -" "exec $*"

# Default Docker CMD will be /sbin/my_init
if [[ $1 = /sbin/my_init ]]; then
  exec /sbin/my_init
else
  # Execute the custom CMD
  exec /bin/bash -c "$*"
fi
