# Step-03: Configuring Jenkins Master and Agents Using Ansible

In this step, we'll automate the **installation** and **configuration** of a **Jenkins Master** and multiple **Jenkins Agent nodes** using **Ansible Playbooks**.

---

## Prerequisites

- Ansible installed on the **Ansible Controller** machine.
- Passwordless SSH access configured between the Controller and all Jenkins nodes (Master + Agents).

---

## Step-by-Step Guide

### 1. 🛠️ Create Ansible Playbooks

We'll create two playbooks:

- One to configure the **Jenkins Master**.
- One to configure the **Jenkins Agents**.

---

#### 📄 Jenkins Master Playbook (`jenkins-master.yml`)

This playbook installs Java, Jenkins, and starts the Jenkins service.

```yaml
---
- name: Install and configure Jenkins Master
  hosts: jenkins-master
  become: yes
  tasks:
    - name: Install Java
      apt:
        name: openjdk-11-jdk
        state: present
        update_cache: yes

    - name: Add Jenkins APT key
      apt_key:
        url: https://pkg.jenkins.io/debian/jenkins.io.key
        state: present

    - name: Add Jenkins APT repository
      apt_repository:
        repo: "deb http://pkg.jenkins.io/debian binary/"
        state: present

    - name: Install Jenkins
      apt:
        name: jenkins
        state: present

    - name: Ensure Jenkins service is started and enabled
      systemd:
        name: jenkins
        enabled: yes
        state: started
```

---

#### 📄 Jenkins Agent Playbook (`jenkins-agents.yml`)

This playbook installs Java, downloads the Jenkins Agent JAR, and sets up a systemd service for the agent.

```yaml
---
- name: Install and configure Jenkins Agents
  hosts: jenkins-agents
  become: yes
  tasks:
    - name: Install Java
      apt:
        name: openjdk-11-jdk
        state: present
        update_cache: yes

    - name: Download Jenkins Agent JAR
      get_url:
        url: http://<jenkins-master-ip>:8080/jnlpJars/agent.jar
        dest: /home/{{ ansible_user }}/agent.jar
        mode: '0755'

    - name: Configure Jenkins Agent as a systemd service
      copy:
        dest: /etc/systemd/system/jenkins-agent.service
        content: |
          [Unit]
          Description=Jenkins Agent
          After=network.target

          [Service]
          User={{ ansible_user }}
          ExecStart=/usr/bin/java -jar /home/{{ ansible_user }}/agent.jar -jnlpUrl http://<jenkins-master-ip>:8080/computer/{{ inventory_hostname }}/slave-agent.jnlp
          Restart=always

          [Install]
          WantedBy=multi-user.target
      notify:
        - Reload systemd
        - Start jenkins-agent service

  handlers:
    - name: Reload systemd
      command: systemctl daemon-reload

    - name: Start jenkins-agent service
      systemd:
        name: jenkins-agent
        enabled: yes
        state: started
```

> 🔥 **Important:**  
> Replace `<jenkins-master-ip>` with the actual IP address of your Jenkins Master server.

---

### 2. 📜 Create the Ansible Inventory File (`inventory.ini`)

Define your Master and Agent nodes:

```ini
[jenkins-master]
jenkins-master ansible_host=<master_ip>

[jenkins-agents]
agent1 ansible_host=<agent1_ip>
agent2 ansible_host=<agent2_ip>
# Add more agents as needed
```

**Tip:**  
You can also define specific SSH user or private key per host if needed.

---

### 3. 🚀 Run the Ansible Playbooks

Execute the playbooks to configure Master and Agent nodes:

```bash
ansible-playbook -i inventory.ini jenkins-master.yml
ansible-playbook -i inventory.ini jenkins-agents.yml
```

✅ This will install and configure Jenkins on all your nodes automatically.

---

### 4. 🌐 Access Jenkins Master Web UI

- Open a browser and navigate to:

  ```
  http://<master_ip>:8080
  ```

- Retrieve the initial admin password:

  ```bash
  sudo cat /var/lib/jenkins/secrets/initialAdminPassword
  ```

- Complete the **Jenkins Setup Wizard**.

---

### 5. ⚙️ Configure Jenkins Agents in Jenkins UI

After Jenkins Master is ready:

- Go to **Manage Jenkins** ➔ **Manage Nodes and Clouds** ➔ **New Node**.
- Add a new node:
  - **Node Name:** (e.g., agent1)
  - **Remote root directory:** (e.g., `/home/<username>`)
  - **Labels:** (e.g., `maven-build`, `linux`)
  - **Usage:** "Only build jobs with label expressions matching this node"
  - **Launch method:** "Launch agent by connecting it to the master"
- Save and connect the agent.

---

### 6. 🛠️ Configure Jenkins Jobs for Maven Build

- When creating or editing a job:
  - Set the **Build Environment** to "Restrict where this project can be run".
  - Enter the **label** you assigned to your Maven Agent (e.g., `maven-build`).

✅ Your Jenkins job will now run on the appropriate agent!

---

### 7. 🧪 Testing

- Trigger a build for a sample Maven project.
- Verify that:
  - The agent connects properly.
  - The build completes successfully.
  - Console logs show tasks running on the expected agent.

---

## Summary

After completing Step-03:

- Jenkins Master is installed and accessible via a browser.
- Jenkins Agents are connected and ready for workloads.
- Builds can be automatically dispatched to agents based on labels and configurations.
