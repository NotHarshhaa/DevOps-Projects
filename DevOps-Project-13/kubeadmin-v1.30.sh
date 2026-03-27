#!/bin/bash

# Update package list and install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Add 'ubuntu' user to the Docker group and apply the change
sudo usermod -aG docker ubuntu
newgrp docker

# Set Docker socket permissions (optional, use with caution)
sudo chmod 777 /var/run/docker.sock

# Add Kubernetes signing key and repo (new URL for v1.30)
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update and install Kubernetes components
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

# Install kube-apiserver via Snap
sudo snap install kube-apiserver

# Verify installations
docker --version
kubectl version --client
kubeadm version

