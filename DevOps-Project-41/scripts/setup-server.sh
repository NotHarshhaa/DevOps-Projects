#!/usr/bin/env bash
# scripts/setup-server.sh
#
# One-time bootstrap for a fresh Ubuntu 22/24 EC2 instance.
# Safe to re-run — every step checks whether it's already done.
#
# Usage:
#   chmod +x scripts/setup-server.sh
#   ./scripts/setup-server.sh

set -euo pipefail

NVM_VERSION="v0.40.1"

echo "==> Updating system packages"
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y git htop wget curl ufw

echo "==> Installing nvm (skipped if already present)"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
fi
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

echo "==> Installing Node LTS"
nvm install --lts
nvm alias default 'lts/*'

echo "==> Installing pm2 globally"
npm install -g pm2

echo "==> Installing nginx (skipped if already present)"
if ! command -v nginx >/dev/null 2>&1; then
  sudo apt install -y nginx
fi

echo "==> Installing certbot via snap (skipped if already present)"
if ! command -v certbot >/dev/null 2>&1; then
  sudo apt remove -y certbot || true
  sudo snap install core
  sudo snap refresh core
  sudo snap install --classic certbot
  sudo ln -sf /snap/bin/certbot /usr/bin/certbot
fi

echo "==> Configuring firewall (OpenSSH + Nginx Full, then enabling ufw)"
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

echo "==> pm2 will survive reboots"
pm2 startup systemd -u "$(whoami)" --hp "$HOME" | tail -n 1 | sudo bash || true

echo ""
echo "✅ Server bootstrap complete."
echo "   Node:    $(node -v)"
echo "   npm:     $(npm -v)"
echo "   pm2:     $(pm2 -v)"
echo "   nginx:   $(nginx -v 2>&1)"
echo "   certbot: $(certbot --version)"
