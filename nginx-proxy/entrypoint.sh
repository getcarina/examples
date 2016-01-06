#!/bin/bash

set -euo pipefail

# Validate environment variables
MISSING=""

[ -z "${UPSTREAM}" ] && MISSING="${MISSING} UPSTREAM"
[ -z "${UPSTREAM_PORT}" ] && MISSING="${MISSING} UPSTREAM_PORT"

if [ "${MISSING}" != "" ]; then
  echo "Missing required environment variables:" >&2
  echo " ${MISSING}" >&2
  exit 1
fi

# Template an nginx.conf
cat <<EOF >/etc/nginx/nginx.conf
user nginx;
worker_processes 2;

events {
  worker_connections 1024;
}

http {
  access_log /var/log/nginx/access.log;
  error_log /var/log/nginx/error.log;

  server {
    location / {
      proxy_pass http://${UPSTREAM}:${UPSTREAM_PORT};
      proxy_set_header Host \$host;
      proxy_set_header X-Forwarded-For \$remote_addr;
    }
  }
}
EOF

# Launch nginx in the foreground
/usr/sbin/nginx -g "daemon off;"
