#!/usr/bin/env bash
# scripts/configure-nginx.sh
#
# Writes a dedicated nginx server block for one domain -> one app port.
# Using a per-domain file under sites-available (instead of editing the
# default site) means you can host several apps on one EC2 box, each
# with its own domain and port, without them clobbering each other.
#
# Usage:
#   ./scripts/configure-nginx.sh app.example.com 5000

set -euo pipefail

DOMAIN="${1:?Usage: configure-nginx.sh <domain> <port>}"
PORT="${2:?Usage: configure-nginx.sh <domain> <port>}"

CONF_PATH="/etc/nginx/sites-available/${DOMAIN}"

echo "==> Writing nginx config: ${DOMAIN} -> http://localhost:${PORT}"
sudo tee "$CONF_PATH" > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN};

    location / {
        proxy_pass http://localhost:${PORT};
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -sf "$CONF_PATH" "/etc/nginx/sites-enabled/${DOMAIN}"

echo "==> Testing nginx config"
sudo nginx -t

echo "==> Reloading nginx"
sudo systemctl reload nginx

cat <<MSG

✅ Nginx is now proxying ${DOMAIN} -> localhost:${PORT}

Next steps:
  1. Point ${DOMAIN}'s DNS A record at this server's Elastic IP.
  2. Once DNS has propagated, issue a free SSL cert:
       sudo certbot --nginx -d ${DOMAIN}
MSG
