#!/bin/bash

set -e

echo "=== JFrog Artifactory OSS + PostgreSQL Setup ==="

# 1. Check root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run this script as root"
  exit 1
fi

# 2. Variables
ARTIFACTORY_DB="artifactory"
ARTIFACTORY_USER="artifactory"
ARTIFACTORY_PASS="ArtifactoryPass123"
POSTGRES_VERSION="14"

# 3. Install dependencies
echo "🔧 Installing Java and PostgreSQL..."
apt update -y
apt install -y openjdk-17-jdk curl gnupg postgresql-$POSTGRES_VERSION

# 4. Setup PostgreSQL
echo "🛠 Configuring PostgreSQL..."
sudo -u postgres psql -c "CREATE USER $ARTIFACTORY_USER WITH PASSWORD '$ARTIFACTORY_PASS';"
sudo -u postgres psql -c "CREATE DATABASE $ARTIFACTORY_DB WITH OWNER $ARTIFACTORY_USER ENCODING 'UTF8';"
sudo -u postgres psql -c "ALTER USER $ARTIFACTORY_USER CREATEDB;"

# 5. Download and install JFrog Artifactory OSS
echo "📦 Adding JFrog APT repo..."
curl -fsSL https://releases.jfrog.io/artifactory/api/gpg/key/public | gpg --dearmor -o /usr/share/keyrings/jfrog.gpg
echo "deb [signed-by=/usr/share/keyrings/jfrog.gpg] https://releases.jfrog.io/artifactory/artifactory-debs focal main" | tee /etc/apt/sources.list.d/jfrog.list

echo "📥 Installing Artifactory OSS..."
apt update -y
apt install -y jfrog-artifactory-oss

# 6. Configure Artifactory to use PostgreSQL
echo "⚙️ Configuring Artifactory to use PostgreSQL..."
ARTIFACTORY_HOME="/opt/jfrog/artifactory"

mkdir -p "$ARTIFACTORY_HOME/var/etc/artifactory"

# JDBC driver setup
echo "📥 Downloading PostgreSQL JDBC driver..."
wget -q https://jdbc.postgresql.org/download/postgresql-42.7.3.jar -O $ARTIFACTORY_HOME/var/bootstrap/artifactory/tomcat/lib/postgresql.jar

# Database config
cat <<EOF > $ARTIFACTORY_HOME/var/etc/artifactory/db.properties
type=postgresql
driver=org.postgresql.Driver
url=jdbc:postgresql://localhost:5432/$ARTIFACTORY_DB
username=$ARTIFACTORY_USER
password=$ARTIFACTORY_PASS
EOF

chown -R artifactory:artifactory "$ARTIFACTORY_HOME/var/etc/artifactory"

# 7. Start Artifactory
echo "🚀 Starting and enabling Artifactory..."
systemctl enable artifactory
systemctl restart artifactory

# 8. Wait for startup
echo "⏳ Waiting for Artifactory to initialize..."
sleep 60

# 9. Final info
IP=$(hostname -I | awk '{print $1}')
echo "✅ Installation Complete!"
echo "🌐 Access Artifactory at: http://$IP:8081/artifactory"
echo "🔐 Default login: admin / [set on first login]"
echo "🗃 Using PostgreSQL DB: $ARTIFACTORY_DB with user $ARTIFACTORY_USER"

