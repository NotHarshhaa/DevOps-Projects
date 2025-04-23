#!/bin/bash

set -euo pipefail

LOG_FILE="/var/log/setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🔍 Detecting OS..."
OS="$(uname -a)"
DISTRO_ID="$(. /etc/os-release && echo "$ID")"

echo "📦 Installing dependencies based on OS: $DISTRO_ID"

if [[ "$DISTRO_ID" == "amzn" ]]; then
  echo "🔧 Amazon Linux 2 detected"

  sudo yum update -y
  sudo yum install -y awscli httpd unzip curl

  echo "📥 Downloading index.html from S3..."
  aws s3 cp s3://ed-web-config-project/index.html /var/www/html/

  echo "🚀 Starting and enabling Apache..."
  sudo systemctl enable httpd
  sudo systemctl start httpd

  echo "📥 Installing CloudWatch Agent..."
  sudo yum install -y amazon-cloudwatch-agent

elif [[ "$DISTRO_ID" == "ubuntu" ]]; then
  echo "🔧 Ubuntu detected"

  sudo apt-get update -y && sudo apt-get upgrade -y
  sudo apt-get install -y unzip curl apache2

  if ! command -v aws &> /dev/null; then
    echo "📦 Installing AWS CLI v2..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
  fi

  echo "📥 Downloading index.html from S3..."
  aws s3 cp s3://ed-web-config-project/index.html /var/www/html/

  echo "🚀 Starting and enabling Apache..."
  sudo systemctl enable apache2
  sudo systemctl start apache2

  echo "📥 Installing CloudWatch Agent..."
  curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
  sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

else
  echo "❌ Unsupported OS: $DISTRO_ID"
  exit 1
fi

echo "🛠️ Configuring CloudWatch Agent..."

# Common CloudWatch config
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat <<EOF | sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/messages",
            "log_group_name": "system-logs",
            "log_stream_name": "{instance_id}",
            "timestamp_format": "%b %d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

echo "🚀 Starting CloudWatch Agent..."
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

echo "✅ Setup completed successfully on $DISTRO_ID!"
echo "📜 Log file: $LOG_FILE"
echo "🔍 Checking Apache status..."
sudo systemctl status httpd || sudo systemctl status apache2
echo "🔍 Checking CloudWatch Agent status..."
sudo systemctl status amazon-cloudwatch-agent
echo "🔍 Checking AWS CLI version..."
aws --version
echo "🔍 Checking installed packages..."
if [[ "$DISTRO_ID" == "amzn" ]]; then
  rpm -qa | grep -E 'httpd|aws-cli|amazon-cloudwatch-agent'
elif [[ "$DISTRO_ID" == "ubuntu" ]]; then
  dpkg -l | grep -E 'apache2|awscli|amazon-cloudwatch-agent'
fi
echo "🔍 Checking index.html content..."
if [[ -f /var/www/html/index.html ]]; then
  echo "✅ index.html exists and is not empty."
  cat /var/www/html/index.html
else
  echo "❌ index.html does not exist or is empty."
fi
echo "🔍 Checking Apache logs..."
if [[ "$DISTRO_ID" == "amzn" ]]; then
  sudo tail -n 10 /var/log/httpd/access_log
  sudo tail -n 10 /var/log/httpd/error_log
elif [[ "$DISTRO_ID" == "ubuntu" ]]; then
  sudo tail -n 10 /var/log/apache2/access.log
  sudo tail -n 10 /var/log/apache2/error.log
fi
echo "🔍 Checking CloudWatch Agent logs..."
if [[ "$DISTRO_ID" == "amzn" ]]; then
  sudo tail -n 10 /opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log
elif [[ "$DISTRO_ID" == "ubuntu" ]]; then
  sudo tail -n 10 /var/log/amazon/ssm/amazon-cloudwatch-agent.log
fi
echo "🔍 Checking system logs..."
if [[ "$DISTRO_ID" == "amzn" ]]; then
  sudo tail -n 10 /var/log/messages
elif [[ "$DISTRO_ID" == "ubuntu" ]]; then
  sudo tail -n 10 /var/log/syslog
fi
echo "🔍 Checking network connectivity..."
ping -c 4 google.com || echo "❌ Network connectivity test failed."
echo "🔍 Checking S3 access..."
aws s3 ls s3://ed-web-config-project/ || echo "❌ S3 access test failed."
echo "🔍 Checking CloudWatch Agent configuration..."
if [[ "$DISTRO_ID" == "amzn" ]]; then
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status
elif [[ "$DISTRO_ID" == "ubuntu" ]]; then
  sudo systemctl status amazon-cloudwatch-agent
fi
