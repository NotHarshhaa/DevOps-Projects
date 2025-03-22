# CI/CD DevOps Pipeline Project: Deployment of Java Application on Kubernetes

![projectbanner](https://cdn.hashnode.com/res/hashnode/image/upload/v1742624835942/cdd382d3-e0e7-4a62-af8c-15629352b2bc.png?w=1600&h=840&fit=crop&crop=entropy&auto=compress,format&format=webp)

## **Introduction**

In the rapidly evolving landscape of software development, adopting DevOps practices has become essential for organizations aiming for agility, efficiency, and quality in their software delivery processes. This project focuses on implementing a robust DevOps Continuous Integration/Continuous Deployment (CI/CD) pipeline, orchestrated by Jenkins, to streamline the development, testing, and deployment phases of a software product.

## **Architecture**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742624121702/0774c721-341f-42f7-8de3-3ae4657a2891.png)

## **Purpose and Objectives**

The primary purpose of this project is to automate the software delivery lifecycle, from code compilation to deployment, thereby accelerating time-to-market, enhancing product quality, and reducing manual errors. The key objectives include:

* Establishing a seamless CI/CD pipeline using Jenkins to automate various stages of the software delivery process.

* Integrating essential DevOps tools such as Maven, SonarQube, Trivy, Nexus Repository, Docker, Kubernetes, Prometheus, and Grafana to ensure comprehensive automation and monitoring.

* Improving code quality through static code analysis and vulnerability scanning.

* Ensuring reliable and consistent deployments on a Kubernetes cluster with proper load balancing.

* Facilitating timely notifications and alerts via email integration for efficient communication and incident management.

* Implementing robust monitoring and alerting mechanisms to track system health and performance.

## **Tools Used**

1. **Jenkins**: Automation orchestration for CI/CD pipeline.

2. **Maven**: Build automation and dependency management.

3. **SonarQube**: Static code analysis for quality assurance.

4. **Trivy**: Vulnerability scanning for Docker images.

5. **Nexus Repository**: Artifact management and version control.

6. **Docker**: Containerization for consistency and portability.

7. **Kubernetes**: Container orchestration for deployment.

8. **Gmail Integration**: Email notifications for pipeline status.

9. **Prometheus and Grafana**: Monitoring and visualization of system metrics.

10. **AWS**: Creating virtual machines.

## **Segment 1: Setting up Virtual Machines on AWS**

To establish the infrastructure required for the DevOps tools setup, virtual machines were provisioned on the Amazon Web Services (AWS) platform. Each virtual machine served a specific purpose in the CI/CD pipeline. Here's an overview of the virtual machines created for different tools:

1. **Kubernetes Master Node**: This virtual machine served as the master node in the Kubernetes cluster. It was responsible for managing the cluster's state, scheduling applications, and coordinating communication between cluster nodes.

2. **Kubernetes Worker Node 1 and Node 2**: These virtual machines acted as worker nodes in the Kubernetes cluster, hosting and running containerized applications. They executed tasks assigned by the master node and provided resources for application deployment and scaling.

3. **SonarQube Server**: A dedicated virtual machine hosted the SonarQube server, which performed static code analysis to ensure code quality and identify potential issues such as bugs, code smells, and security vulnerabilities.

4. **Nexus Repository Manager**: Another virtual machine hosted the Nexus Repository Manager, serving as a centralized repository for storing and managing build artifacts, Docker images, and other dependencies used in the CI/CD pipeline.

5. **Jenkins Server**: A virtual machine was allocated for the Jenkins server, which served as the central hub for orchestrating the CI/CD pipeline. Jenkins coordinated the execution of pipeline stages, triggered builds, and integrated with other DevOps tools for seamless automation.

6. **Monitoring Server (Prometheus and Grafana)**: A single virtual machine hosted both Prometheus and Grafana for monitoring and visualization of system metrics. Prometheus collected metrics from various components of the CI/CD pipeline, while Grafana provided interactive dashboards for real-time monitoring and analysis. 4 Each virtual machine was configured with the necessary resources, including CPU, memory, and storage, to support the respective tool's functionalities and accommodate the workload demands of the CI/CD pipeline. Additionally, security measures such as access controls, network configurations, and encryption were implemented to safeguard the virtualized infrastructure and data integrity.

   #### **<mark>EC2 Instances :</mark>**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623924551/8c9d48b2-341a-45ac-9cf9-3ff01efa2dd1.png)

   #### **<mark>Security Group:</mark>**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623875504/7deeffb1-9a19-4203-a335-daa0ee571e54.png)

7. **Set Up K8s Cluster Using Kubeadm**

    This guide outlines the steps to set up a Kubernetes cluster using kubeadm.

    **Prerequisites:**

    * Ubuntu OS (Xenial or later)

    * Sudo privileges

    * Internet access

    * t2.medium instance type or higher

    **AWS Setup:**

    * Ensure all instances are in the same Security Group.

    * Open port 6443 in the Security Group to allow worker nodes to join the cluster.

    **Execute on Both "Master" & "Worker Node":**

    Run the following commands on both the master and worker nodes to prepare them for kubeadm.

    ```bash
    # Disable swap
    sudo swapoff -a
    ```

    Create the `.conf` file to load the modules at bootup:

    ```bash
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF
    
    sudo modprobe overlay
    sudo modprobe br_netfilter
    ```

    Set sysctl parameters required by the setup, ensuring they persist across reboots:

    ```bash
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward = 1
    EOF
    
    # Apply sysctl parameters without reboot
    sudo sysctl --system
    ```

    **Install CRIO Runtime:**

    ```bash
    sudo apt-get update -y
    sudo apt-get install -y software-properties-common curl apt-transport-https ca-certificates gpg
    
    sudo curl -fsSL https://pkgs.k8s.io/addons:/crio:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
    
    echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list
    
    sudo apt-get update -y
    sudo apt-get install -y cri-o
    sudo systemctl daemon-reload
    sudo systemctl enable crio --now
    sudo systemctl start crio.service
    
    echo "CRI runtime installed successfully"
    ```

    Add Kubernetes APT repository and install required packages:

    ```bash
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    sudo apt-get update -y
    sudo apt-get install -y kubelet="1.29.0-*" kubectl="1.29.0-*" kubeadm="1.29.0-*"
    sudo apt-get update -y
    sudo apt-get install -y jq
    sudo systemctl enable --now kubelet
    sudo systemctl start kubelet
    ```

    Execute ONLY on the "Master Node":

    ```bash
    sudo kubeadm config images pull
    sudo kubeadm init
    
    mkdir -p "$HOME"/.kube
    sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
    sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
    ```

    **Set up the Network Plugin and Kubernetes Cluster:**

    ```bash
    # Apply Calico network plugin
    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
    
    # Create kubeadm token and copy it
    kubeadm token create --print-join-command
    ```

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623817867/dd6c447a-8289-43c1-a78e-4f8585ee1b1d.png)

   ### **Execute on ALL Worker Nodes:**

    ```bash
    # Perform pre-flight checks
    sudo kubeadm reset pre-flight checks
    
    # Paste the join command you got from the master node and append --v=5 at the end
    sudo <your-token> --v=5
    ```

    **Verify Cluster Connection on Master Node:**

    ![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623658833/5c454406-cd90-4446-8fc4-5e638761754b.png)

    ```bash
    kubectl get nodes
    ```

    **Installing Jenkins on Ubuntu**:

    ```bash
    #!/bin/bash
    
    # Install OpenJDK 17 JRE Headless
    sudo apt install openjdk-17-jre-headless -y
    
    # Download Jenkins GPG key
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    
    # Add Jenkins repository to package manager sources
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    
    # Update package manager repositories
    sudo apt-get update
    
    # Install Jenkins
    sudo apt-get install jenkins -y
    ```

    Save this script in a file, for example, `install_`[`jenkins.sh`](http://jenkins.sh), and make it executable using:

    ```bash
    chmod +x install_jenkins.sh
    ```

    Then, you can run the script using:

    ```bash
    ./install_jenkins.sh
    ```

    **Install kubectl:**

    ```bash
    curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin
    kubectl version --short --client
    ```

    **Install Docker for future use:**

    ```bash
    #!/bin/bash
    
    # Update package manager repositories
    sudo apt-get update
    
    # Install necessary dependencies
    sudo apt-get install -y ca-certificates curl
    
    # Create directory for Docker GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    
    # Download Docker's GPG key
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    
    # Ensure proper permissions for the key
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add Docker repository to Apt sources
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package manager repositories
    sudo apt-get update
    
    # Install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

    Save this script in a file, for example, `install_`[`docker.sh`](http://docker.sh), and make it executable using:

    ```bash
    chmod +x install_docker.sh
    ```

    Then, you can run the script using:

    ```bash
    ./install_docker.sh
    ```

    **Set Up Nexus:**

    ```bash
    #!/bin/bash
    
    # Update package manager repositories
    sudo apt-get update
    
    # Install necessary dependencies
    sudo apt-get install -y ca-certificates curl
    
    # Create directory for Docker GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    
    # Download Docker's GPG key
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    
    # Ensure proper permissions for the key
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add Docker repository to Apt sources
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    ```

    Update package manager repositories and install Docker:

    ```bash
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

    Save this script in a file, for example, `install_`[`docker.sh`](http://docker.sh), and make it executable using:

    ```bash
    chmod +x install_docker.sh
    ```

    Then, you can run the script using:

    ```bash
    ./install_docker.sh
    ```

    Create Nexus using a Docker container:

    To create a Docker container running Nexus 3 and exposing it on port 8081, use the following command:

    ```bash
    docker run -d --name nexus -p 8081:8081 sonatype/nexus3:latest
    ```

    This command does the following:

    * `-d`: Detaches the container and runs it in the background.

    * `--name nexus`: Specifies the name of the container as "nexus".

    * `-p 8081:8081`: Maps port 8081 on the host to port 8081 on the container, allowing access to Nexus through port 8081.

    * `sonatype/nexus3:latest`: Specifies the Docker image to use for the container, in this case, the latest version of Nexus 3 from the Sonatype repository.

    After running this command, Nexus will be accessible on your host machine at [`http://IP:8081`](http://IP:8081).

    **Get Nexus initial password:**

    Your provided commands are correct for accessing the Nexus password stored in the container. **Here's a breakdown of the steps:**

    1. **Get Container ID**: Find out the ID of the Nexus container by running:

        ```bash
        docker ps
        ```

        This command lists all running containers along with their IDs, among other information.

    2. **Access Container's Bash Shell**: Once you have the container ID, execute the `docker exec` command to access the container's bash shell:

        ```bash
        docker exec -it <container_ID> /bin/bash
        ```

        Replace `<container_ID>` with the actual ID of the Nexus container.

    3. **Navigate to Nexus Directory**: Inside the container's bash shell, navigate to the directory where Nexus stores its configuration:

        ```bash
        cd sonatype-work/nexus3
        ```

    4. **View Admin Password**: View the admin password by displaying the contents of the `admin.password` file:

        ```bash
        cat admin.password
        ```

    5. **Exit the Container Shell**: Once you have retrieved the password, exit the container's bash shell:

        ```bash
        exit
        ```

    This process allows you to access the Nexus admin password stored within the container. Make sure to keep this password secure, as it grants administrative access to your Nexus instance.

    Set Up SonarQube:

    Execute these commands on the SonarQube VM:

    ```bash
    #!/bin/bashpipeline { agent any
    ```

    Update package manager repositories and install Docker:

    ```bash
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    
    # Create directory for Docker GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    
    # Download Docker's GPG key
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    
    # Ensure proper permissions for the key
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add Docker repository to Apt sources
    echo "deb [arch=$(dpkg --print-architecture) signed by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package manager repositories
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

    Save this script in a file, for example, `install_`[`docker.sh`](http://docker.sh), and make it executable using:

    ```bash
    chmod +x install_docker.sh
    ```

    Then, you can run the script using:

    ```bash
    ./install_docker.sh
    ```

    Create SonarQube Docker container:

    To run SonarQube in a Docker container, follow these steps:

    1. Open your terminal or command prompt.

    2. Run the following command:

        ```bash
        docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
        ```

        This command will download the `sonarqube:lts-community` Docker image from Docker Hub if it's not already available locally. It will create a container named "sonar" from this image, running it in detached mode (`-d` flag) and mapping port 9000 on the host machine to port 9000 in the container (`-p 9000:9000` flag).

    3. Access SonarQube by opening a web browser and navigating to [`http://VmIP:9000`](http://VmIP:9000). This will start the SonarQube server, and you should be able to access it using the provided URL. If you're running Docker on a remote server or a different port, replace [`localhost`](http://localhost) with the appropriate hostname or IP address and adjust the port accordingly.

        ---

## **Segment 2: Private Git Setup**

Steps to create a private Git repository, generate a personal access token, connect to the repository, and push code to it:

1. 1. **Create a Private Git Repository:**

        * Go to your preferred Git hosting platform (e.g., GitHub, GitLab, Bitbucket).

        * Log in to your account or sign up if you don't have one.

        * Create a new repository and set it as private.

   2. **Generate a Personal Access Token:**

        * Navigate to your account settings or profile settings.

        * Look for the "Developer settings" or "Personal access tokens" section.

        * Generate a new token, providing it with the necessary permissions (e.g., repo access).

   3. **Clone the Repository Locally:**

        * Open Git Bash or your terminal.

        * Navigate to the directory where you want to clone the repository.

        * Use the `git clone` command followed by the repository's URL. For example:

            ```bash
            git clone <repository_URL>
            ```

        Replace `<repository_URL>` with the URL of your private repository.

   4. **Add Your Source Code Files:**

        * Navigate into the cloned repository directory.

        * Paste your source code files or create new ones inside this directory.

   5. **Stage and Commit Changes:**

        * Use the `git add` command to stage the changes:

            ```bash
            git add .
            ```

        * Use the `git commit` command to commit the staged changes along with a meaningful message:

            ```bash
            git commit -m "Your commit message here"
            ```

   6. **Push Changes to the Repository:**

        * Use the `git push` command to push your committed changes to the remote repository:

            ```bash
            git push
            ```

        * If it's your first time pushing to this repository, you might need to specify the remote and branch:

            ```bash
            git push -u origin master
            ```

        Replace `master` with the branch name if you're pushing to a different branch.

   7. **Enter Personal Access Token as Authentication:**

        * When prompted for credentials during the push, enter your username (usually your email) and use your personal access token as the password.

    By following these steps, you'll be able to create a private Git repository, connect to it using Git Bash, and push your code changes securely using a personal access token for authentication.

    ---

   ## **Segment 3: CI/CD**

    Install the following plugins in Jenkins:

    1. **Eclipse Temurin Installer:**

        * This plugin enables Jenkins to automatically install and configure the Eclipse Temurin JDK (formerly known as AdoptOpenJDK).

        * To install, go to Jenkins dashboard -&gt; Manage Jenkins -&gt; Manage Plugins -&gt; Available tab.

        * Search for "Eclipse Temurin Installer" and select it.

        * Click on the "Install without restart" button.

    2. **Pipeline Maven Integration:**

        * This plugin provides Maven support for Jenkins Pipeline.

        * It allows you to use Maven commands directly within your Jenkins Pipeline scripts.

        * To install, follow the same steps as above, but search for "Pipeline Maven Integration" instead.

    3. **Config File Provider:**

        * This plugin allows you to define configuration files (e.g., properties, XML, JSON) centrally in Jenkins.

        * These configurations can then be referenced and used by your Jenkins jobs.

        * Install it using the same procedure as mentioned earlier.

    4. **SonarQube Scanner:**

        * SonarQube is a code quality and security analysis tool.

        * This plugin integrates Jenkins with SonarQube by providing a scanner that analyzes code during builds.

        * You can install it from the Jenkins plugin manager as described above.

    5. **Kubernetes CLI:**

        * This plugin allows Jenkins to interact with Kubernetes clusters using the Kubernetes command-line tool (kubectl).

        * It's useful for tasks like deploying applications to Kubernetes from Jenkins jobs.

        * Install it through the plugin manager.

    6. **Kubernetes:**

        * This plugin integrates Jenkins with Kubernetes by allowing Jenkins agents to run as pods within a Kubernetes cluster.

        * It provides dynamic scaling and resource optimization capabilities for Jenkins builds.

        * Install it from the Jenkins plugin manager.

    7. **Docker:**

        * This plugin allows Jenkins to interact with Docker, enabling Docker builds and integration with Docker registries.

        * You can use it to build Docker images, run Docker containers, and push/pull images from Docker registries.

        * Install it from the plugin manager.

    8. **Docker Pipeline Step:**

        * This plugin extends Jenkins Pipeline with steps to build, publish, and run Docker containers as part of your Pipeline scripts.

        * It provides a convenient way to manage Docker containers directly from Jenkins Pipelines.

        * Install it through the plugin manager like the others.

    After installing these plugins, you may need to configure them according to your specific environment and requirements. This typically involves setting up credentials, configuring paths, and specifying options in Jenkins global configuration or individual job configurations. Each plugin usually comes with its own set of documentation to guide you through the configuration process.

    **Jenkins Pipeline**

    Create a new Pipeline job.

```go
pipeline {
    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/jaiswaladi246/Boardgame.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('Trivy File system scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame -Dsonar.java.binaries=.
                    '''
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifacts to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                    sh "mvn deploy"
                }
            }
        }
        stage('Build and Tag Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker build -t jaiswaladi246/Boardgame:latest ."
                    }
                }
            }
        }
        stage('Docker Image Scan') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "trivy image --format table -o trivy-image-report.html jaiswaladi246/Boardgame:latest"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker push jaiswaladi246/Boardgame:latest"
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://172.31.8.22:6443') {
                    sh "kubectl apply -f deployment-service.yaml"
                    sh "kubectl get pods -n webapps"
                }
            }
        }
    }
    post {
        always {
            script {
                def jobName = env.JOB_NAME
                def buildNumber = env.BUILD_NUMBER
                def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
                def bannerColor = pipelineStatus.toUpperCase() == 'SUCCESS' ? 'green' : 'red'
                def body = """
                ${jobName} - Build ${buildNumber}
                Pipeline Status: ${pipelineStatus.toUpperCase()}
                Check the console output.
                """
                emailext(
                    subject: "${jobName} - Build ${buildNumber} - ${pipelineStatus.toUpperCase()}",
                    body: body,
                    to: 'jaiswaladi246@gmail.com',
                    from: 'jenkins@example.com',
                    replyTo: 'jenkins@example.com',
                    mimeType: 'text/html',
                    attachmentsPattern: 'trivy-image-report.html'
                )
            }
        }
    }
}
```

---

## **Segment 4: Monitoring**

**Prometheus**

* Links to download Prometheus, Node Exporter, and Blackbox Exporter: [https://prometheus.io/download/](https://prometheus.io/download/)

* Extract and Run Prometheus:

  * After downloading Prometheus, extract the `.tar` file.

  * Navigate to the extracted directory and run `./prometheus &`.

  * By default, Prometheus runs on port 9090. Access it using `http://<instance_IP>:9090`.

* Similarly, download and run Blackbox Exporter:

  * Run `./blackbox_exporter &`.

**Grafana**

* Links to download Grafana: [https://grafana.com/grafana/download](https://grafana.com/grafana/download)

* Alternatively, run this code on the Monitoring VM to install Grafana:

    ```bash
    sudo apt-get install -y adduser libfontconfig1 musl
    wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.4.2_amd64.deb
    sudo dpkg -i grafana-enterprise_10.4.2_amd64.deb
    ```

* Once installed, run:

    ```bash
    sudo /bin/systemctl start grafana-server
    ```

* By default, Grafana runs on port 3000. Access it using `http://<instance_IP>:3000`.

**Configure Prometheus**

* Edit the `prometheus.yaml` file:

    ```yaml
    scrape_configs:
      - job_name: 'blackbox'
        metrics_path: /probe
        params:
          module: [http_2xx] # Look for an HTTP 200 response.
        static_configs:
          - targets:
            - http://prometheus.io # Target to probe with HTTP.
            - https://prometheus.io # Target to probe with HTTPS.
            - http://example.com:8080 # Target to probe with HTTP on port 8080.
        relabel_configs:
          - source_labels: [__address__]
            target_label: __param_target
          - source_labels: [__param_target]
            target_label: instance
          - target_label: __address__
            replacement: <instance_IP>:9115
    ```

* Replace `<instance_IP>` with your instance IP address.

* Restart Prometheus:

    ```bash
    pgrep prometheus
    ```

* Use the ID obtained to kill the process and restart it.

**Add Prometheus as a Data Source in Grafana**

* Go to Grafana &gt; Data Sources &gt; Prometheus.

* Add the IP address of Prometheus and import the dashboard from the web.

### **Results:**

#### **<mark>JENKINS PIPELINE:</mark>**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623342403/c85feb9a-dcef-46be-8e8a-572ca172c6ad.png)

#### **<mark>PROMETHEUS:</mark>**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623416764/f62506cc-b35b-48de-bcb4-48c4a2062549.png)

#### **<mark>BLACKBOX:</mark>**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623455040/2d6273de-ba79-43e6-ad7a-989f38defd2d.png)

#### **<mark>GRAFANA:</mark>**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623511607/1cafa610-9f2b-41ee-8ec4-80b7f7ad1122.png)

#### **<mark>APPLICATION:</mark>**

![](https://cdn.hashnode.com/res/hashnode/image/upload/v1742623551950/72da2ff5-9643-48a0-be97-47be6037af61.png)

### **Conclusion**

The successful implementation of the DevOps CI/CD pipeline project marks a significant milestone in enhancing the efficiency, reliability, and quality of software delivery processes. By automating key aspects of the software development lifecycle, including compilation, testing, deployment, and monitoring, the project has enabled rapid and consistent delivery of software releases, contributing to improved time-to-market and customer satisfaction.

### **Acknowledgment of Contributions**

I want to express my gratitude to [**DevOps Shack**](https://www.devopsshack.com/) for their excellent project and implementation guide.

### **Final Thoughts**

Looking ahead, the project's impact extends beyond its immediate benefits, paving the way for continuous improvement and innovation in software development practices. By embracing DevOps principles and leveraging cutting-edge tools and technologies, we have laid a solid foundation for future projects to build upon. The scalability, flexibility, and resilience of the CI/CD pipeline ensure its adaptability to evolving requirements and technological advancements, positioning our organization for long-term success in a competitive market landscape.

### **References**

1. Jenkins Documentation: [https://www.jenkins.io/doc/](https://www.jenkins.io/doc/)

2. Maven Documentation: [https://maven.apache.org/guides/index.html](https://maven.apache.org/guides/index.html)

3. SonarQube Documentation: [https://docs.sonarqube.org/latest/](https://docs.sonarqube.org/latest/)

4. Trivy Documentation: [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy)

5. Nexus Repository Manager Documentation: [https://help.sonatype.com/repomanager3](https://help.sonatype.com/repomanager3)

6. Docker Documentation: [https://docs.docker.com/](https://docs.docker.com/)

7. Kubernetes Documentation: [https://kubernetes.io/docs/](https://kubernetes.io/docs/)

8. Prometheus Documentation: [https://prometheus.io/docs/](https://prometheus.io/docs/)

9. Grafana Documentation: [https://grafana.com/docs/](https://grafana.com/docs/)

*These resources provided valuable insights, guidance, and support throughout the project lifecycle, enabling us to achieve our goals effectively.*

## 🛠️ **Author & Community**

This project is crafted by [**Harshhaa**](https://github.com/NotHarshhaa) 💡.  
I’d love to hear your feedback! Feel free to share your thoughts.

---

### 📧 **Connect with me:**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/harshhaa-vardhan-reddy) [![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/NotHarshhaa) [![Telegram](https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/prodevopsguy) [![Dev.to](https://img.shields.io/badge/Dev.to-0A0A0A?style=for-the-badge&logo=dev.to&logoColor=white)](https://dev.to/notharshhaa) [![Hashnode](https://img.shields.io/badge/Hashnode-2962FF?style=for-the-badge&logo=hashnode&logoColor=white)](https://hashnode.com/@prodevopsguy)

---

### 📢 **Stay Connected**

![Follow Me](https://imgur.com/2j7GSPs.png)
