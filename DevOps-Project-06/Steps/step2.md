# About Step-02

Configuring SSH keys for passwordless authentication between Ansible Controller and Agent nodes is a common practice to enhance security and streamline automation workflows. This allows you to execute Ansible playbooks and commands on the remote nodes without the need to enter a password each time. Here's a step-by-step guide on how to set up passwordless SSH authentication:

1. **Generate SSH Key Pair on Ansible Controller:**
   On your Ansible Controller instance, generate an SSH key pair if you don't already have one.

   ```bash
   ssh-keygen
   ```

   Follow the prompts to generate the key pair. By default, the private key is stored in `~/.ssh/id_rsa` and the public key in `~/.ssh/id_rsa.pub`.

2. **Copy Public Key to Agent Nodes:**
   Use the `ssh-copy-id` command to copy the public key from the Ansible Controller to each of the Agent nodes. Replace `<username>` with your username and `<agent_ip>` with the IP address of each Agent node.

   ```bash
   ssh-copy-id <username>@<agent_ip>
   ```

   You'll be prompted to enter the password for the user on the Agent node. After entering the password, the public key will be added to the `~/.ssh/authorized_keys` file on the Agent node.

3. **Test SSH Connection:**
   Test the SSH connection from the Ansible Controller to the Agent nodes to ensure passwordless authentication is working:

   ```bash
   ssh <username>@<agent_ip>
   ```

   You should be able to log in without being prompted for a password.

4. **Ansible Inventory Configuration:**
   In your Ansible inventory file (usually located at `/etc/ansible/hosts`), list the IP addresses or hostnames of your Agent nodes under the appropriate group. For example:

   ```plaintext
   [agents]
   agent1 ansible_host=<agent_ip_1>
   agent2 ansible_host=<agent_ip_2>
   ```

5. **Ansible Playbook Execution:**
   Now you can create Ansible playbooks and execute them on the Agent nodes. Ansible will use the SSH key pair for authentication, allowing passwordless execution. For example:

   ```yaml
   - name: Example playbook
     hosts: agents
     tasks:
       - name: Run a command
         command: echo "Hello from Ansible" > /tmp/ansible_test.txt
   ```

   Run the playbook using the `ansible-playbook` command:

   ```bash
   ansible-playbook playbook.yml
   ```

With passwordless SSH authentication in place, you can seamlessly integrate Ansible with your Jenkins pipelines or other automation processes, providing a secure and efficient way to manage your infrastructure and applications. Just remember to manage your SSH keys securely and follow best practices for key management to ensure the ongoing security of your environment.