# Step-09: Build and Push Docker Image to Artifactory using Jenkins

<details>
<summary><strong>1. Example Jenkinsfile</strong></summary>

<br/>

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Build your project and generate the JAR file
                sh 'mvn clean package' // Replace with your specific build command
            }
        }

        stage('Docker Build and Publish') {
            steps {
                script {
                    // Build Docker image using the JAR file
                    def dockerImage = docker.build("your-docker-image-name:${BUILD_NUMBER}", '.')

                    // Authenticate with Artifactory Docker registry
                    docker.withRegistry('https://your-artifactory-url', 'your-artifactory-credentials-id') {
                        // Push the Docker image to Artifactory repository
                        dockerImage.push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
```

</details>

---

<details>
<summary><strong>2. Key Sections Explained</strong></summary>

<br/>

### Build Docker Image:
- The `docker.build` command creates a Docker image using the Dockerfile in the current directory (`.`).
- Naming convention: `"your-docker-image-name:${BUILD_NUMBER}"`.
- **Replace** the image name with your project-specific naming convention.

---

### Push Docker Image to Artifactory:
- The `docker.withRegistry` block handles:
  - Authentication to your Artifactory Docker registry.
  - Pushing the built Docker image.
- **Important placeholders to replace:**
  - `https://your-artifactory-url` ➔ Your Artifactory Docker registry URL.
  - `your-artifactory-credentials-id` ➔ ID of the credentials stored in Jenkins.

</details>

---

<details>
<summary><strong>3. Important Notes</strong></summary>

<br/>

- **Credential Setup:**  
  Ensure Jenkins has Docker registry credentials properly configured in "Manage Credentials."
  
- **Dockerfile Presence:**  
  Your project root should contain a valid `Dockerfile`.

- **Customize Build Commands:**  
  Adjust `sh 'mvn clean package'` or other shell steps according to your technology stack (e.g., Gradle, npm, etc.).

- **Security Tip:**  
  Never hard-code sensitive information like access tokens directly inside the Jenkinsfile.

- **Tagging Strategy:**  
  Using `${BUILD_NUMBER}` automatically tags images uniquely for each build.

</details>
