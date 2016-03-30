#!/bin/bash

set -euo pipefail

# Validate environment variables
: "${UPSTREAM:?Set UPSTREAM using --env}"
: "${UPSTREAM_PORT?Set UPSTREAM_PORT using --env}"
PROTOCOL=${PROTOCOL:=HTTP}

# Template an nginx.conf
cat <<EOF >nginx.conf
user nginx;
worker_processes 2;

events {
  worker_connections 1024;
}
EOF

echo "pr = $PROTOCOL"

if [ "$PROTOCOL" = "HTTP" ]; then
cat <<EOF >>nginx.conf

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
elif [ "$PROTOCOL" == "TCP" ]; then
cat <<EOF >>nginx.conf

stream {
  server {
    listen 3306;
    proxy_pass ${UPSTREAM}:${UPSTREAM_PORT};
  }
}
EOF
else
echo "Unknown PROTOCOL. Valid values are HTTP or TCP."
fi

# Launch nginx in the foreground
/usr/sbin/nginx -g "daemon off;"
