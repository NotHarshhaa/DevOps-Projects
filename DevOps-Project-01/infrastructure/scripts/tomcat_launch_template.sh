#!/bin/bash

set -e

TOMCAT_VERSION="10.1.24"
TOMCAT_USER="tomcat"
INSTALL_DIR="/opt/tomcat"

echo "=== Apache Tomcat Installer ==="

# 1. Ensure root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run as root (sudo)"
  exit 1
fi

# 2. Detect OS
OS=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')
echo "📦 Detected OS: $OS"

# 3. Install Java (Tomcat 10 requires Java 11+)
echo "📥 Installing Java..."
case "$OS" in
  ubuntu|debian)
    apt update -y
    apt install -y openjdk-17-jdk curl tar
    ;;
  centos|rhel|rocky|almalinux)
    yum install -y java-17-openjdk curl tar
    ;;
  amzn)
    yum install -y java-17-openjdk curl tar
    ;;
  *)
    echo "❌ Unsupported OS: $OS"
    exit 1
    ;;
esac

# 4. Create tomcat user
if ! id "$TOMCAT_USER" >/dev/null 2>&1; then
  useradd -r -m -U -d "$INSTALL_DIR" -s /bin/false $TOMCAT_USER
  echo "👤 Created user: $TOMCAT_USER"
fi

# 5. Download and install Tomcat
echo "⬇️ Downloading Tomcat $TOMCAT_VERSION..."
cd /tmp
curl -O https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz

echo "📂 Installing Tomcat to $INSTALL_DIR..."
mkdir -p $INSTALL_DIR
tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C $INSTALL_DIR --strip-components=1
rm apache-tomcat-${TOMCAT_VERSION}.tar.gz
chown -R $TOMCAT_USER:$TOMCAT_USER $INSTALL_DIR

# 6. Make scripts executable
chmod +x $INSTALL_DIR/bin/*.sh

# 7. Create systemd service
echo "🛠 Creating systemd service..."
cat <<EOF > /etc/systemd/system/tomcat.service
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

User=$TOMCAT_USER
Group=$TOMCAT_USER
UMask=0007

Environment="JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))"
Environment="CATALINA_PID=$INSTALL_DIR/temp/tomcat.pid"
Environment="CATALINA_HOME=$INSTALL_DIR"
Environment="CATALINA_BASE=$INSTALL_DIR"
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=$INSTALL_DIR/bin/startup.sh
ExecStop=$INSTALL_DIR/bin/shutdown.sh

RestartSec=10
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 8. Start and enable service
echo "🚀 Starting Tomcat..."
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

# 9. Show access info
echo "✅ Tomcat installed and running!"
echo "🌐 Access it via: http://<your-server-ip>:8080"
