#!/bin/bash

set -e

echo "=== JFrog Artifactory OSS Installer ==="

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run this script as root (sudo ./install-artifactory.sh)"
  exit 1
fi

# Detect OS
OS=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
echo "📦 Detected OS: $OS"

# Install dependencies
echo "📥 Installing dependencies..."
case "$OS" in
  ubuntu|debian)
    apt update -y
    apt install -y curl gnupg openjdk-17-jdk
    ;;
  centos|rhel|rocky|almalinux)
    yum install -y curl java-17-openjdk
    ;;
  amzn)
    yum install -y curl java-17-openjdk
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

# Create user if not exists
if ! id "artifactory" >/dev/null 2>&1; then
  useradd -r -m -s /bin/bash artifactory
  echo "👤 Created user 'artifactory'"
fi

# Download and extract Artifactory OSS
ARTIFACTORY_VERSION="7.77.9"
ARTIFACTORY_URL="https://releases.jfrog.io/artifactory/artifactory-oss/org/artifactory/oss/jfrog-artifactory-oss/${ARTIFACTORY_VERSION}/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-linux.tar.gz"

echo "⬇️ Downloading Artifactory OSS v${ARTIFACTORY_VERSION}..."
cd /opt
curl -L -O "${ARTIFACTORY_URL}"
tar -xzf jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-linux.tar.gz
rm jfrog-artifactory-oss-${ARTIFACTORY_VERSION}-linux.tar.gz
mv jfrog-artifactory-oss-${ARTIFACTORY_VERSION} artifactory
chown -R artifactory:artifactory /opt/artifactory

# Create systemd service
echo "🛠 Creating systemd service..."
cat <<EOF > /etc/systemd/system/artifactory.service
[Unit]
Description=JFrog Artifactory OSS
After=network.target

[Service]
Type=forking
User=artifactory
Group=artifactory
ExecStart=/opt/artifactory/app/bin/artifactory.sh start
ExecStop=/opt/artifactory/app/bin/artifactory.sh stop
TimeoutSec=300
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

# Enable and start service
echo "🚀 Starting Artifactory..."
systemctl daemon-reload
systemctl enable artifactory
systemctl start artifactory

# Show status and access info
echo "✅ Artifactory installed and running!"
echo "🌐 Access it via: http://<your-server-ip>:8082"
