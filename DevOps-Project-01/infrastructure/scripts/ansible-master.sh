#!/bin/bash

set -e

echo "[INFO] Detecting OS..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION_ID=$VERSION_ID
else
    echo "[ERROR] Cannot detect the operating system."
    exit 1
fi

install_ansible_debian() {
    echo "[INFO] Updating package index..."
    sudo apt update

    echo "[INFO] Installing dependencies..."
    sudo apt install -y software-properties-common

    echo "[INFO] Adding Ansible PPA..."
    sudo add-apt-repository --yes --update ppa:ansible/ansible

    echo "[INFO] Installing Ansible..."
    sudo apt install -y ansible
}

install_ansible_rhel() {
    echo "[INFO] Installing EPEL repository..."
    sudo dnf install -y epel-release

    echo "[INFO] Installing Ansible..."
    sudo dnf install -y ansible
}

case "$OS" in
    ubuntu|debian)
        install_ansible_debian
        ;;
    centos|rhel|rocky|almalinux|fedora)
        install_ansible_rhel
        ;;
    *)
        echo "[ERROR] Unsupported OS: $OS"
        exit 1
        ;;
esac

echo "[SUCCESS] Ansible has been installed."
ansible --version

ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.general
echo "[INFO] Ansible collections installed."


sudo apt install -y python3-pip
echo "[INFO] Python3 pip installed."
pip install boto3 botocore
echo "[INFO] Python packages installed."
