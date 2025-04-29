# Step-02: Setting Up Passwordless SSH Authentication for Ansible

In this step, we configure **passwordless SSH authentication** between the **Ansible Controller** and **Agent nodes**.  
This enhances both **security** and **automation efficiency**, allowing Ansible to run commands and playbooks on remote nodes **without needing a password**.

---

## Why Passwordless SSH?

- Enables **seamless automation** of configuration tasks with Ansible.
- Strengthens **security** by avoiding password-based logins.
- Essential for integrating Ansible with **CI/CD pipelines** (e.g., Jenkins).

---

## Step-by-Step Guide

### 1. 🔑 Generate SSH Key Pair on Ansible Controller

On your **Ansible Controller instance**, generate a new SSH key pair (or use an existing one).

```bash
ssh-keygen
```

- When prompted, press `Enter` to accept the default file location (`~/.ssh/id_rsa`).
- You can optionally set a passphrase for extra security (recommended).

Generated files:

- **Private Key:** `~/.ssh/id_rsa`
- **Public Key:** `~/.ssh/id_rsa.pub`

---

### 2. 📤 Copy Public Key to Agent Nodes

Use the `ssh-copy-id` command to copy your Controller's public key to each **Agent Node**.

```bash
ssh-copy-id <username>@<agent_ip>
```

- Replace `<username>` with the user account on the Agent node.
- Replace `<agent_ip>` with the IP address of the Agent.
- You will be prompted for the user's password **only once** during setup.

Behind the scenes, this command:

- Appends your Controller’s public key into the Agent’s `~/.ssh/authorized_keys` file.

---

### 3. 🧪 Verify Passwordless SSH Access

Test the SSH connection to ensure passwordless login is successful:

```bash
ssh <username>@<agent_ip>
```

✅ You should be able to log in **without** being prompted for a password.

---

### 4. 📜 Configure the Ansible Inventory File

Define your Agent nodes in the Ansible **inventory file** (usually `/etc/ansible/hosts`).

Example:

```ini
[agents]
agent1 ansible_host=<agent_ip_1>
agent2 ansible_host=<agent_ip_2>
```

- `agent1` and `agent2` are aliases used in your playbooks.
- `ansible_host` specifies the actual IP address of each node.

**Tip:**  
You can also specify usernames, SSH keys, and ports in the inventory if needed:

```ini
[agents]
agent1 ansible_host=<agent_ip_1> ansible_user=<username> ansible_ssh_private_key_file=~/.ssh/id_rsa
```

---

### 5. 🚀 Execute an Ansible Playbook

Now you can create a basic Ansible playbook and execute it on your agents!

Example Playbook (`playbook.yml`):

```yaml
- name: Example Playbook
  hosts: agents
  tasks:
    - name: Create a test file
      command: echo "Hello from Ansible" > /tmp/ansible_test.txt
```

Run the playbook:

```bash
ansible-playbook playbook.yml
```

✅ Ansible will automatically use your SSH key to connect and execute tasks without password prompts.

---

## Best Practices for SSH Key Management

- 🔒 **Protect private keys**: Set proper file permissions (`chmod 600 ~/.ssh/id_rsa`).
- 🔐 **Use passphrases**: Add a passphrase to your private key for extra security.
- 🔄 **Rotate keys** regularly to minimize risk if compromised.
- 🗄️ **Backup your keys** securely in encrypted storage.

---

✅ **After completing Step-02, your Ansible Controller can securely and automatically manage your Agent nodes, paving the way for full automation workflows!**
