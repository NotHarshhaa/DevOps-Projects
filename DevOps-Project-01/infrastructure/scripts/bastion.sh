#! /bin/bash

# Install AWS CLI (for Amazon Linux 2 or Ubuntu)
if ! command -v aws &> /dev/null; then
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "amzn" ]]; then
      yum install -y awscli
    elif [[ "$ID" == "ubuntu" ]]; then
      apt-get update
      apt-get install -y awscli
    fi
  fi
fi

# Get instance ID and region from instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# Get Name tag of the instance
INSTANCE_NAME=$(aws ec2 describe-tags \
  --region "$REGION" \
  --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" \
  --query "Tags[0].Value" --output text)

# Set the hostname
if [ -n "$INSTANCE_NAME" ]; then
  hostnamectl set-hostname "$INSTANCE_NAME"
  echo "$INSTANCE_NAME" > /etc/hostname
  echo "127.0.0.1 $INSTANCE_NAME" >> /etc/hosts
fi

# Detect Linux distribution
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "$ID"
  else
    echo "unknown"
  fi
}

DISTRO=$(detect_distro)
echo "🔍 Detected OS: $DISTRO"

install_kubectl() {
  echo "📦 Installing kubectl..."
  case "$DISTRO" in
    ubuntu|debian)
      sudo apt-get update -y
      sudo apt-get install -y apt-transport-https ca-certificates curl
      sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
      echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | \
        sudo tee /etc/apt/sources.list.d/kubernetes.list
      sudo apt-get update -y
      sudo apt-get install -y kubectl
      ;;
    centos|rhel|amzn)
      cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
      sudo yum install -y kubectl
      ;;
    fedora)
      sudo dnf install -y kubectl
      ;;
    opensuse*|suse)
      echo "⚠️ kubectl install not officially supported for SUSE via this script."
      ;;
    *)
      echo "❌ Unsupported distro for kubectl."
      ;;
  esac
}

install_ansible() {
  echo "📦 Installing Ansible..."
  case "$DISTRO" in
    ubuntu|debian)
      sudo apt update -y
      sudo apt install -y software-properties-common
      sudo add-apt-repository --yes --update ppa:ansible/ansible
      sudo apt install -y ansible
      ;;
    centos|rhel|amzn)
      sudo yum install -y epel-release
      sudo yum install -y ansible
      ;;
    fedora)
      sudo dnf install -y ansible
      ;;
    opensuse*|suse)
      sudo zypper install -y ansible
      ;;
    *)
      echo "❌ Unsupported distro for Ansible."
      ;;
  esac
}

install_terraform() {
  echo "📦 Installing Terraform..."
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  case "$DISTRO" in
    ubuntu|debian)
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
        sudo tee /etc/apt/sources.list.d/hashicorp.list
      sudo apt update -y
      sudo apt install -y terraform
      ;;
    centos|rhel|amzn)
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
      sudo yum install -y terraform
      ;;
    fedora)
      sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
      sudo dnf install -y terraform
      ;;
    opensuse*|suse)
      echo "⚠️ Please install Terraform manually on SUSE."
      ;;
    *)
      echo "❌ Unsupported distro for Terraform."
      ;;
  esac
}

install_docker() {
  echo "📦 Installing Docker..."
  case "$DISTRO" in
    ubuntu|debian)
      sudo apt-get remove -y docker docker-engine docker.io containerd runc || true
      sudo apt-get update -y
      sudo apt-get install -y ca-certificates curl gnupg lsb-release
      sudo mkdir -p /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    centos|rhel|amzn)
      sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest \
        docker-latest-logrotate docker-logrotate docker-engine || true
      sudo yum install -y yum-utils
      sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
      sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    fedora)
      sudo dnf remove -y docker docker-client docker-client-latest docker-common docker-latest \
        docker-latest-logrotate docker-logrotate docker-engine || true
      sudo dnf -y install dnf-plugins-core
      sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
      sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      ;;
    opensuse*|suse)
      sudo zypper install -y docker
      ;;
    *)
      echo "❌ Unsupported distro for Docker."
      ;;
  esac

  sudo systemctl enable docker
  sudo systemctl start docker
  sudo usermod -aG docker "$USER"
}

# Execute all installers
install_kubectl
install_ansible
install_terraform
install_docker

echo "✅ All tools installed. You may need to log out and back in to use Docker without sudo."

ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.general
echo "[INFO] Ansible collections installed."


sudo apt install -y python3-pip
echo "[INFO] Python3 pip installed."
pip install boto3 botocore pymongo psycopg2-binary redis sqlalchemy
echo "[INFO] Python packages with database drivers installed."

# Install database clients for RDS access
install_database_clients() {
  echo "📦 Installing database clients..."
  case "$DISTRO" in
    ubuntu|debian)
      sudo apt-get update -y
      # MySQL/MariaDB client
      sudo apt-get install -y mysql-client
      # PostgreSQL client
      sudo apt-get install -y postgresql-client
      # MongoDB client
      sudo apt-get install -y mongodb-clients
      # Redis client
      sudo apt-get install -y redis-tools
      # Oracle client (basic)
      sudo apt-get install -y alien libaio1
      ;;
    centos|rhel|amzn)
      # MySQL client
      sudo yum install -y mysql
      # PostgreSQL client
      sudo yum install -y postgresql
      # MongoDB client
      sudo yum install -y mongodb-org-shell
      # Redis client
      sudo yum install -y redis
      ;;
    fedora)
      sudo dnf install -y mysql postgresql mongodb redis
      ;;
    *)
      echo "❌ Unsupported distro for database clients."
      ;;
  esac
  echo "✅ Database clients installed."
}

install_database_clients

