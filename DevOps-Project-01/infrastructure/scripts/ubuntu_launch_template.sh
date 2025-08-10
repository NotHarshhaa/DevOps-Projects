#!/bin/bash

set -e

echo "=== Universal NGINX Installer for Linux ==="

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run this script as root (use sudo)"
  exit 1
fi

# Detect OS and package manager
detect_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
  else
    echo "❌ Cannot detect OS type"
    exit 1
  fi
}

install_nginx() {
  case "$OS" in
    ubuntu|debian)
      echo "📦 Detected $OS — using apt"
      apt update -y
      apt install -y nginx
      ;;
    centos|rhel|rocky|almalinux)
      echo "📦 Detected $OS — using yum"
      yum install -y epel-release
      yum install -y nginx
      ;;
    amzn)
      echo "📦 Detected Amazon Linux — using amazon-linux-extras"
      amazon-linux-extras enable nginx1
      yum clean metadata
      yum install -y nginx
      ;;
    fedora)
      echo "📦 Detected Fedora — using dnf"
      dnf install -y nginx
      ;;
    opensuse*|sles)
      echo "📦 Detected SUSE — using zypper"
      zypper install -y nginx
      ;;
    *)
      echo "❌ Unsupported or unrecognized OS: $OS"
      exit 1
      ;;
  esac
}

start_nginx() {
  echo "🚀 Starting and enabling NGINX..."
  systemctl start nginx
  systemctl enable nginx
}

configure_firewall() {
  echo "🔒 Checking for firewall tools..."
  if command -v ufw >/dev/null; then
    echo "🔓 Allowing HTTP (80) with ufw..."
    ufw allow 'Nginx HTTP' || ufw allow 80
  elif command -v firewall-cmd >/dev/null; then
    echo "🔓 Allowing HTTP (80) with firewalld..."
    firewall-cmd --permanent --add-service=http
    firewall-cmd --reload
  elif command -v iptables >/dev/null; then
    echo "🔓 Allowing HTTP (80) with iptables..."
    iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    iptables-save > /etc/iptables/rules.v4 2>/dev/null || true
  else
    echo "⚠️ No firewall tool detected — skipping"
  fi
}

show_status() {
  echo "🔍 NGINX service status:"
  systemctl status nginx --no-pager || echo "⚠️ NGINX may not be running"
  IP=$(hostname -I | awk '{print $1}')
  echo "✅ Visit: http://$IP"
}

### MAIN
detect_os
install_nginx
start_nginx
#configure_firewall
show_status
