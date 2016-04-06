#!/bin/bash

set -euo pipefail

# Validate environment variables
: "${UPSTREAM:?Set UPSTREAM using --env}"
: "${UPSTREAM_PORT?Set UPSTREAM_PORT using --env}"
PROTOCOL=${PROTOCOL:=HTTP}

# Template an nginx.conf
cat <<EOF >/etc/nginx/nginx.conf
user nginx;
worker_processes 2;

events {
  worker_connections 1024;
}
EOF

if [ "$PROTOCOL" = "HTTP" ]; then
cat <<EOF >>/etc/nginx/nginx.conf

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
cat <<EOF >>/etc/nginx/nginx.conf

stream {
  server {
    listen ${UPSTREAM_PORT};
    proxy_pass ${UPSTREAM}:${UPSTREAM_PORT};
  }
}
EOF
else
echo "Unknown PROTOCOL. Valid values are HTTP or TCP."
fi

echo "Proxy ${PROTOCOL} for ${UPSTREAM}:${UPSTREAM_PORT}"

# Launch nginx in the foreground
/usr/sbin/nginx -g "daemon off;"
