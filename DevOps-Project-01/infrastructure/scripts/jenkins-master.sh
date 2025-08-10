#!/bin/bash

set -e

# Update packages and install Java
sudo apt update
sudo apt install -y openjdk-17-jdk wget gnupg2 curl

# Add Jenkins repo and key
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update
sudo apt install -y jenkins

# Start and enable Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Wait for Jenkins to be fully up (simple wait, improve with a loop if you want)
echo "Waiting for Jenkins to start..."
sleep 30

# Path to initial admin password
ADMIN_PASS_FILE="/var/lib/jenkins/secrets/initialAdminPassword"

if [ -f "$ADMIN_PASS_FILE" ]; then
    echo "Initial Jenkins Admin Password:"
    sudo cat "$ADMIN_PASS_FILE"
else
    echo "Initial Admin Password file not found."
fi

# Function to install plugins via Jenkins CLI
install_plugins() {
    # Download Jenkins CLI jar
    JENKINS_CLI_JAR="/tmp/jenkins-cli.jar"
    JENKINS_URL="http://localhost:8080"

    curl -sLo $JENKINS_CLI_JAR $JENKINS_URL/jnlpJars/jenkins-cli.jar

    # Read admin password
    ADMIN_PASS=$(sudo cat "$ADMIN_PASS_FILE")

    # Plugins list to install
    PLUGINS=(
        "Jfrog"                        # JFrog Artifactory plugin
        "Terraform"                   # Terraform plugin for Jenkins
        "Ansible"                     # Ansible plugin for Jenkins
        "Docker"                      # Docker plugin for Jenkins
        "Kubernetes"                 # Kubernetes plugin for Jenkins
        "Kubernetes Credentials" # Kubernetes credentials plugin
        "Kubernetes CLI"         # Kubernetes CLI plugin
        "Maven Integration"          # Maven support
        "Gradle"                        # Gradle support
        Sonar Quality Gates # SonarQube plugin for Jenkins
        "SonarQube"                # SonarQube server integration
        "SonarQube Scanner"      # SonarQube scanner for Jenkins
        "Swarm"                         # Docker Swarm plugin
        "git"
        "workflow-aggregator"
        "blueocean"
        "pipeline-stage-view"
        "credentials-binding"
        "job-dsl"                        # Allows programmatic job creation
        "pipeline-github-lib"           # Shared libraries for pipelines from GitHub
        "github"                        # GitHub integration
        "git-client"                    # Git client plugin
        "ssh-slaves"                    # SSH agent plugin (for connecting to agents)
        "matrix-auth"                   # Role-based access control
        "email-ext"                     # Extended email notifications
        "mailer"                        # Core mailer plugin
        "ldap"                          # LDAP authentication support
        "configuration-as-code"        # Jenkins Configuration as Code (JCasC)
        "credentials"                   # Core credentials plugin
        "docker-Pipeline"              # Docker pipeline support
        "docker-plugin"                # Docker build agent support
        "docker-workflow"              # Docker support inside pipelines
        "ansicolor"                     # Colored console output
        "pipeline-utility-steps"       # Useful pipeline steps like file I/O
        "timestamper"                   # Adds timestamps to console output
        "ant"                           # Ant build support (legacy but common)
        "gradle"                        # Gradle build tool integration
        "nodejs"                        # Node.js support
        "slack"                         # Slack notifications
        "kubernetes"                   # Kubernetes plugin for Jenkins
        "kubernetes-cd"                # Continuous deployment to Kubernetes
        "pipeline-milestone-step"      # Milestone steps for pipelines
        "pipeline-stage-step"          # Stage steps for pipelines
        "pipeline-github-webhook"      # GitHub webhook support for pipelines
        "pipeline-restful-api"         # RESTful API for pipelines
        "pipeline-build-step"          # Build steps for pipelines
        "pipeline-input-step"          # Input steps for pipelines
        "pipeline-graph-view"          # Graph view for pipelines
        "pipeline-stage-tags-metadata" # Metadata for pipeline stages
        "pipeline-shared-libraries"    # Shared libraries for pipelines
        "pipeline-model-definition"    # Model definition for pipelines
        "pipeline-maven"               # Maven support for pipelines
        "pipeline-git"                 # Git support for pipelines
        "pipeline-jenkinsfile-runner"  # Jenkinsfile runner for pipelines
        "pipeline-jenkinsfile-runner-core" # Core support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-maven" # Maven support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-gradle" # Gradle support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-docker" # Docker support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-kubernetes" # Kubernetes support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-ssh" # SSH support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-ssh-agent" # SSH agent support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-ssh-slaves" # SSH slaves support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-ssh-agent-credentials" # SSH agent credentials support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-ssh-slaves-credentials" # SSH slaves credentials support for Jenkinsfile runner
        "pipeline-jenkinsfile-runner-ssh-agent-credentials-binding" # SSH agent credentials binding support
        "pipeline-jenkinsfile-runner-ssh-slaves-credentials-binding" # SSH slaves credentials binding support
        "pipeline-jenkinsfile-runner-ssh-agent-credentials-binding-git" # SSH agent credentials binding for Git
        )

    # Install plugins
    for plugin in "${PLUGINS[@]}"; do
        echo "Installing plugin: $plugin"
        echo "$ADMIN_PASS" | java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth admin:$ADMIN_PASS install-plugin $plugin
    done

    # Restart Jenkins to apply plugins
    echo "$ADMIN_PASS" | java -jar $JENKINS_CLI_JAR -s $JENKINS_URL -auth admin:$ADMIN_PASS safe-restart
}

install_plugins

echo "Jenkins setup completed. Access Jenkins at http://your_server_ip:8080"
