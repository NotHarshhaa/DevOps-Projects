#!/bin/bash

# ==== CONFIGURATION ====
# create SSH key pair for ansible
ssh-keygen -t rsa -b 4096 -f ~/.ssh/bastion_key -N ""
echo "[INFO] SSH key pair created at ~/.ssh/bastion_key and ~/.ssh/bastion_key.pub"

# SSH details
PRIVATE_INSTANCE_USER="ubuntu"
PRIVATE_INSTANCE_KEY="/home/ubuntu/key/terraform-key.pem"

# Path to the public key to distribute
PUBLIC_KEY_FILE="/home/ubuntu/.ssh/bastion_key.pub"

# Optional: tag filter to select specific instances
# TAG_KEY="Role"
# TAG_VALUE="private-instance"

# Region (update if needed)
AWS_REGION="ap-south-1"

# ==== VALIDATION ====

if [ ! -f "$PUBLIC_KEY_FILE" ]; then
  echo "❌ Public key not found at $PUBLIC_KEY_FILE"
  exit 1
fi

echo "🔍 Fetching EC2 private IPs with tag $TAG_KEY=$TAG_VALUE in $AWS_REGION..."

PRIVATE_IPS=$(aws ec2 describe-instances \
  --region "$AWS_REGION" \
  --filters "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].PrivateIpAddress" \
  --output text)

if [ -z "$PRIVATE_IPS" ]; then
  echo "❌ No matching instances found."
  exit 1
fi

echo "✅ Found instances:"
echo "$PRIVATE_IPS"

# ==== MAIN LOOP ====

for ip in $PRIVATE_IPS; do
  echo "🚀 Copying public key to $ip..."

  scp -i "$PRIVATE_INSTANCE_KEY" -o StrictHostKeyChecking=no "$PUBLIC_KEY_FILE" "$PRIVATE_INSTANCE_USER@$ip:/tmp/bastion_key.pub"

  ssh -i "$PRIVATE_INSTANCE_KEY" -o StrictHostKeyChecking=no "$PRIVATE_INSTANCE_USER@$ip" <<EOF
  
    mkdir -p ~/.ssh
    cat /tmp/bastion_key.pub >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/authorized_keys
    rm /tmp/bastion_key.pub
EOF
done
# ==== POST-COPY CHECK ====
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/bastion_key
echo "[SUCCESS] Public key copied to all instances."
echo "[INFO] You can now SSH into the instances using:"
for ip in $PRIVATE_IPS; do
  echo "ssh -i ~/.ssh/bastion_key $PRIVATE_INSTANCE_USER@$ip"
done