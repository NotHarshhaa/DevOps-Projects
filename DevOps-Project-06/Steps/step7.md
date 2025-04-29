# Step-07: SonarCloud Integration with Jenkins

<details>
<summary><strong>1. Generate an Access Token in SonarCloud and Add SonarQube Server Credentials in Jenkins</strong></summary>

<br/>

### Generating an Access Token in SonarCloud

1. **Log in to SonarCloud:**  
   Log in to your SonarCloud account.

2. **Navigate to User Token:**  
   Click on your profile picture ➔ "My Account" ➔ "Security" ➔ "Generate Token."

3. **Provide Token Details:**  
   Give it a name, set expiry (optional), and select your organization.

4. **Generate Token:**  
   Click "Generate" and securely save the token.

---

### Adding SonarQube Server Credentials in Jenkins:

1. **Log in to Jenkins:**  
   Open your Jenkins Master web interface.

2. **Manage Credentials:**  
   ➔ "Manage Jenkins" ➔ "Manage Credentials" ➔ "Global" domain ➔ "Add Credentials."

3. **Add Secret Text:**  
   - **Kind:** Secret text  
   - **Secret:** Paste the SonarCloud access token  
   - **ID:** Set a unique identifier  
   - **Description:** (Optional) Helpful label

4. **Save:**  
   Click "Save."

---

### Configuring SonarCloud in Jenkins Job:

1. **Configure Jenkins Job:**  
   Edit/create a job ➔ Find "SonarQube Scanner" section.

2. **Server Setup:**  
   - Choose your configured SonarQube server.
   - Select the credentials you just added.

3. **Save:**  
   Save the job configuration.

Now Jenkins can run SonarCloud code analysis!

</details>

---

<details>
<summary><strong>2. Install SonarQube Scanner Plugin</strong></summary>

<br/>

1. **Log in to Jenkins:**  
   Open Jenkins web interface.

2. **Manage Plugins:**  
   ➔ "Manage Jenkins" ➔ "Manage Plugins" ➔ "Available" tab.

3. **Search:**  
   Look for "SonarQube Scanner" plugin.

4. **Install Plugin:**  
   Select it ➔ Click "Install without restart."

5. **Optional Restart:**  
   If needed, restart Jenkins after installation.

The plugin is now ready for use!

</details>

---

<details>
<summary><strong>3. Add SonarQube Server in the Jenkins System Section</strong></summary>

<br/>

1. **Log in to Jenkins.**

2. **Configure System:**  
   ➔ "Manage Jenkins" ➔ "Configure System."

3. **Add SonarQube Server:**  
   Scroll down ➔ "SonarQube servers" ➔ "Add SonarQube."

4. **Server Details:**  
   - **Name:** Descriptive label  
   - **Server URL:** Your SonarCloud URL  
   - **Authentication Token:** Select previously added credentials.

5. **Save Configuration.**

6. **Optional:**  
   Test the connection to verify communication.

</details>

---

<details>
<summary><strong>4. Add SonarQube Scanner in the Jenkins Tools Section</strong></summary>

<br/>

1. **Log in to Jenkins.**

2. **Global Tool Configuration:**  
   ➔ "Manage Jenkins" ➔ "Global Tool Configuration."

3. **SonarQube Scanner:**  
   Scroll down ➔ "SonarQube Scanner" ➔ "Add SonarQube Scanner."

4. **Configure Installation:**  
   - **Name:** Friendly name  
   - **Install Automatically:** Check if you want Jenkins to auto-download  
   - **Version:** Choose preferred version.

5. **Save Configuration.**

6. **Optional:**  
   Restart Jenkins if required.

</details>

---

<details>
<summary><strong>5. Configure Organization, Project in SonarCloud & sonar-project.properties File</strong></summary>

<br/>

### Organization and Project Setup in SonarCloud:

1. **Log in to SonarCloud.**

2. **Create Organization:**  
   If not done already ➔ Create new org.

3. **Create Project:**  
   Inside your organization ➔ Create new project ➔ Fill project key, name, visibility.

---

### Create sonar-project.properties:

1. **Create File:**  
   In your repo root ➔ Create `sonar-project.properties`.

2. **Sample Content:**

   ```properties
   sonar.projectKey=your-project-key
   sonar.projectName=Your Project Name
   sonar.projectVersion=1.0
   sonar.sources=src
   sonar.language=java
   sonar.sourceEncoding=UTF-8
   ```

3. **Commit and Push:**  
   Push the file to your repository.

</details>

---

<details>
<summary><strong>6. Configure Jenkinsfile with SonarQube, Unit Tests, and Build Stages</strong></summary>

<br/>

### Example Jenkinsfile:

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
                sh 'mvn clean package' // Update with your project build command
            }
        }

        stage('Unit Tests') {
            steps {
                sh 'mvn test' // Or any other unit testing framework
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'Your-SonarQube-Scanner-Name'
            }
            steps {
                withSonarQubeEnv('Your-SonarQube-Server-Name') {
                    sh '${scannerHome}/bin/sonar-scanner'
                }
            }
        }
    }
}
```

- Replace `Your-SonarQube-Scanner-Name` with the scanner name configured in Tools.
- Replace `Your-SonarQube-Server-Name` with the server configured in System settings.

---

Now, every Jenkins build will:
- Checkout code
- Build
- Run unit tests
- Perform SonarCloud code quality analysis

</details>
