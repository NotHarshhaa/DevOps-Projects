# About Step-03

Configuring Jenkins Master and Agent nodes using Ansible involves defining Ansible playbooks to automate the installation and configuration of Jenkins components. Here's a step-by-step guide on how you might achieve this:

**Note:** Before you begin, ensure you have Ansible installed on your machine and have SSH access to the target nodes (Jenkins Master and Agent nodes).

1. **Create Ansible Playbooks:**

   Create two Ansible playbooks: one for configuring the Jenkins Master and another for configuring Jenkins Agents.

   **Jenkins Master Playbook (`jenkins-master.yml`):**

   ```yaml
   ---
   - name: Install and configure Jenkins Master
     hosts: jenkins-master
     tasks:
       - name: Install Java
         apt:
           name: openjdk-11-jdk
           state: present

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

       - name: Start Jenkins service
         systemd:
           name: jenkins
           enabled: yes
           state: started
   ```

   **Jenkins Agent Playbook (`jenkins-agents.yml`):**

   ```yaml
   ---
   - name: Install and configure Jenkins Agents
     hosts: jenkins-agents
     tasks:
       - name: Install Java
         apt:
           name: openjdk-11-jdk
           state: present

       - name: Download Jenkins Agent JAR
         get_url:
           url: http://<jenkins-master>:<jenkins-port>/jnlpJars/agent.jar
           dest: /home/{{ ansible_user }}/agent.jar
           mode: 0755

       - name: Configure Jenkins Agent as a service
         systemd:
           name: jenkins-agent
           enabled: yes
           state: started
           daemon_reload: yes
           unit_content: |
             [Unit]
             Description=Jenkins Agent
             After=network.target

             [Service]
             User={{ ansible_user }}
             ExecStart=/usr/bin/java -jar /home/{{ ansible_user }}/agent.jar -jnlpUrl http://<jenkins-master>:<jenkins-port>/computer/{{ inventory_hostname }}/slave-agent.jnlp
             Restart=always

             [Install]
             WantedBy=multi-user.target
   ```

2. **Inventory File:**

   Create an Ansible inventory file (`inventory.ini`) to define your target nodes:

   ```plaintext
   [jenkins-master]
   jenkins-master-hostname-or-ip

   [jenkins-agents]
   agent1 ansible_host=agent1-hostname-or-ip
   agent2 ansible_host=agent2-hostname-or-ip
   # Add more agents as needed
   ```

3. **Run Ansible Playbooks:**

   Run the Ansible playbooks using the `ansible-playbook` command:

   ```bash
   ansible-playbook -i inventory.ini jenkins-master.yml
   ansible-playbook -i inventory.ini jenkins-agents.yml
   ```

4. **Configure Jenkins Master:**

   Access the Jenkins Master's web interface (`http://jenkins-master-hostname-or-ip:8080`) to complete the setup. You'll need to retrieve the initial admin password from the server and follow the setup wizard.

5. **Configure Jenkins Agent as Maven Build Server:**

   - In Jenkins, navigate to "Manage Jenkins" > "Manage Nodes and Clouds" > "New Node".
   - Configure the Agent as follows:
     - Node name: Choose a name for your agent.
     - Remote root directory: Specify a directory on the agent where builds will be performed.
     - Labels: Assign a label to the agent (e.g., "maven-build").
     - Usage: Choose "Only build jobs with label expressions matching this node".
     - Launch method: Choose "Launch agent by connecting it to the master".
   - Save the configuration.

6. **Configure Jenkins Jobs:**

   Create or modify Jenkins jobs to use the Maven tool for builds. Configure the job's "Build Environment" to use the previously defined label ("maven-build") to ensure the job runs on the Maven Build agent.

7. **Testing:**

   Test your Jenkins setup by running jobs on the Maven Build agent. Monitor the console output and verify that the build process is successful.

This outline provides a general approach to configuring Jenkins Master and Agent nodes using Ansible and setting up a Jenkins Agent as a Maven Build server. Adapt the steps to your specific environment and requirements.
