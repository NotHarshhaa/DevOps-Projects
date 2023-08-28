# About Step-07

## 1. Generated an access token in SonarCloud and added SonarQube server credentials in Jenkins Master.

To integrate SonarCloud with Jenkins, you'll need to generate an access token in SonarCloud and then add SonarQube server credentials in Jenkins. Here's how you can do it:

### Generating an Access Token in SonarCloud:

1. **Log in to SonarCloud:**
   Log in to your SonarCloud account.

2. **Navigate to User Token:**
   Click on your profile picture in the top right corner and select "My Account."

3. **Generate Token:**
   In the "Security" tab, click on "Security Tokens." Then click on "Generate" to create a new access token.

4. **Provide Token Details:**
   Give your token a name and, if needed, set an expiration date. Select the appropriate organization if you're a member of multiple organizations.

5. **Generate Token:**
   Click "Generate" to create the access token. Make sure to copy and securely store the generated token, as you won't be able to see it again.

### Adding SonarQube Server Credentials in Jenkins:

1. **Log in to Jenkins:**
   Log in to your Jenkins Master's web interface.

2. **Access Credentials:**
   Click on "Manage Jenkins" from the home page, and then select "Manage Credentials" from the dropdown.

3. **Add Credentials:**
   Click on the "Global" domain (or any other domain you prefer) and then click on "Add Credentials" from the left-hand side menu.

4. **Choose Credentials Kind:**
   In the "Add Credentials" page, select the kind of credentials you want to add. For SonarQube access, you'll generally use "Secret text."

5. **Fill in Details:**
   - Secret: Paste the access token you generated in SonarCloud.
   - ID: A unique identifier for these credentials.
   - Description (Optional): Add a description to help you identify these credentials later.

6. **Save Credentials:**
   Click the "OK" or "Save" button to save the credentials. They will now be available for use in Jenkins.

### Configuring SonarCloud in Jenkins Job:

1. **Create or Configure a Jenkins Job:**
   Create a new Jenkins job or edit an existing one.

2. **Configure SonarQube Scanner:**
   In the job configuration, look for the SonarQube Scanner section. This section might be labeled as "Build Environment," "Build Settings," or something similar, depending on your job configuration.

3. **Add SonarQube Server Configuration:**
   - Choose the SonarQube server you want to use (you need to configure this server beforehand).
   - Select the SonarQube server credentials you added earlier from the dropdown.
   - Configure other SonarQube settings like project key, project name, and any other relevant properties.

4. **Save Configuration:**
   Save the configuration of your Jenkins job.

Now, whenever you run this Jenkins job, it will use the provided SonarQube access token to connect to your SonarCloud instance and perform code analysis on your projects. This helps ensure code quality by detecting code issues, vulnerabilities, and other quality-related metrics.

## 2.Installed Sonarqube scanner plugin.

To install the SonarQube Scanner plugin in Jenkins, follow these steps:

1. **Log in to Jenkins:**
   Log in to your Jenkins Master's web interface.

2. **Access Plugin Manager:**
   Click on "Manage Jenkins" from the home page.

3. **Install Plugins:**
   In the "Manage Jenkins" page, select "Manage Plugins" from the dropdown.

4. **Available Plugins Tab:**
   In the "Plugin Manager" page, navigate to the "Available" tab. This tab lists all the plugins that you can install.

5. **Search for SonarQube Scanner Plugin:**
   In the search bar, type "SonarQube Scanner" and hit Enter. The search results will display the SonarQube Scanner plugin.

6. **Select Plugin for Installation:**
   Check the checkbox next to the "SonarQube Scanner" plugin.

7. **Install Selected Plugins:**
   Once you've selected the plugin, scroll down and click the "Install without restart" button. This will start the installation process.

8. **Installation Process:**
   Jenkins will begin installing the selected plugin. You'll see the progress on the screen.

9. **Installation Complete:**
   Once the installation is complete, you'll see a notification. The plugin should now be listed as installed in the "Installed" tab of the "Plugin Manager" page.

10. **Optional: Restart Jenkins (if required):**
    Some plugins might require a Jenkins restart to function properly. If you're prompted to do so, you can restart Jenkins by clicking the "Restart Jenkins when no jobs are running" button in the "Plugin Manager" page.

The SonarQube Scanner plugin should now be installed and available for use in your Jenkins environment. You can proceed to configure your Jenkins jobs to use the SonarQube Scanner to perform code analysis on your projects.

## 3.Added Sonarqube server to the Jenkins Master in System section.

To add a SonarQube server to the Jenkins Master in the System section, follow these steps:

1. **Log in to Jenkins:**
   Log in to your Jenkins Master's web interface.

2. **Access System Configuration:**
   Click on "Manage Jenkins" from the home page.

3. **System Configuration:**
   In the "Manage Jenkins" page, select "Configure System" from the dropdown. This is where you can configure various global settings for Jenkins.

4. **Scroll Down to SonarQube Servers:**
   Scroll down the "Configure System" page until you find the section labeled "SonarQube servers."

5. **Add a SonarQube Server:**
   Click on the "Add SonarQube" button. This will open a new configuration block where you can specify the details of the SonarQube server.

6. **Provide Server Details:**
   In the configuration block, you'll need to provide the following details:

   - **Name:** A descriptive name for the SonarQube server configuration.
   - **Server URL:** The URL of your SonarQube server, including the protocol (e.g., http or https).
   - **Server authentication token:** This is where you select the SonarQube server credentials you previously added in Jenkins. Choose the appropriate credentials from the dropdown.

7. **Save Configuration:**
   After providing the necessary information, click the "Save" or "Apply" button at the bottom of the page to save the SonarQube server configuration.

8. **Test Connection (Optional):**
   After saving the configuration, you might have the option to test the connection to the SonarQube server. This can help ensure that Jenkins can communicate with the SonarQube instance.

9. **Verify Configuration:**
   Once the configuration is saved, you'll see the SonarQube server listed in the "SonarQube servers" section on the "Configure System" page.

10. **Restart Jenkins (if required):**
    In some cases, changes to the system configuration might require a Jenkins restart to take effect. If prompted, you can restart Jenkins to apply the changes.

With the SonarQube server configured in the System section of Jenkins, you can now use this configuration in your Jenkins jobs to perform code analysis and integration with SonarQube. When configuring your Jenkins jobs, you'll select the appropriate SonarQube server configuration to use for each job's analysis.

## 4. Added Sonarqube scanner to the Jenkins Master in Tools section.

To add the SonarQube Scanner to the Jenkins Master in the Tools section, follow these steps:

1. **Log in to Jenkins:**
   Log in to your Jenkins Master's web interface.

2. **Access Global Tool Configuration:**
   Click on "Manage Jenkins" from the home page.

3. **Global Tool Configuration:**
   In the "Manage Jenkins" page, select "Global Tool Configuration" from the dropdown. This is where you can configure tools that are used globally across Jenkins.

4. **Scroll Down to SonarQube Scanner:**
   Scroll down the "Global Tool Configuration" page until you find the section labeled "SonarQube Scanner."

5. **Add SonarQube Scanner:**
   Click on the "Add SonarQube Scanner" button. This will open a new configuration block where you can specify the details of the SonarQube Scanner installation.

6. **Provide Scanner Installation Details:**
   In the configuration block, you'll need to provide the following details:

   - **Name:** A descriptive name for the SonarQube Scanner installation.
   - **Install automatically:** Check this option if you want Jenkins to automatically download and install the SonarQube Scanner. If not checked, you'll need to provide the path to an existing SonarQube Scanner installation on the Jenkins server.
   - **SonarQube Scanner version:** Choose the version of the SonarQube Scanner you want to install.

7. **Save Configuration:**
   After providing the necessary information, click the "Save" or "Apply" button at the bottom of the page to save the SonarQube Scanner configuration.

8. **Restart Jenkins (if required):**
   In some cases, changes to the global tool configuration might require a Jenkins restart to take effect. If prompted, you can restart Jenkins to apply the changes.

With the SonarQube Scanner added to the Tools section of Jenkins, you can now reference this installation in your Jenkins jobs' configuration. When setting up a job that requires SonarQube analysis, you'll be able to select the configured SonarQube Scanner from the dropdown list of available tools.

## 5. Configured an organization and project in SonarCloud and wrote a sonar-project. properties file.

Configuring an organization and project in SonarCloud involves setting up your SonarCloud account, creating a project, and then creating a `sonar-project.properties` file to define project-specific configuration for analysis. Here's how you can do it:

### Configure Organization and Project in SonarCloud:

1. **Create a SonarCloud Account:**
   If you haven't already, create an account on the SonarCloud platform.

2. **Log in to SonarCloud:**
   Log in to your SonarCloud account.

3. **Create an Organization:**
   - Once logged in, create a new organization or use an existing one. Organizations help you group projects together.
   - Follow the prompts to set up the organization.

4. **Create a Project:**
   - Within your organization, create a new project.
   - Specify the project's key, display name, and visibility (public or private).

### Create a `sonar-project.properties` File:

1. **Create the File:**
   In your project's source code repository, create a `sonar-project.properties` file. This file will contain configuration settings for SonarCloud analysis.

2. **Configure Properties:**
   Open the `sonar-project.properties` file and define the required properties for your project. Below are some common properties:

   ```properties
   # Project identification
   sonar.projectKey=your-project-key
   sonar.projectName=Your Project Name
   sonar.projectVersion=1.0

   # Source code directory
   sonar.sources=src

   # Language
   sonar.language=java

   # Encoding of the source code
   sonar.sourceEncoding=UTF-8
   ```

   Adjust the values to match your project's details and structure. You might also need to add properties specific to your project's programming language and technologies.

3. **Commit and Push:**
   Commit the `sonar-project.properties` file to your repository and push the changes.

### Running SonarQube Analysis:

1. **Configure Jenkins Job (if applicable):**
   If you're using Jenkins to build and analyze your project, configure the job to execute SonarQube analysis using the SonarQube Scanner you added earlier.

2. **Execute Analysis:**
   Run the analysis by invoking the SonarQube Scanner using your build tool's command line or through Jenkins. The scanner will read the properties from the `sonar-project.properties` file to configure the analysis.

3. **View Analysis Results:**
   After the analysis is complete, the results will be visible in your SonarCloud dashboard. You can view code quality metrics, issues, and other analysis details.

Remember that the `sonar-project.properties` file defines project-specific settings for SonarQube analysis. As your project evolves, you might need to update this file to reflect changes in your codebase and analysis requirements.

## 6. Added sonarqube, unit tests and build stages in the Jenkinsfile.

Adding SonarQube analysis, unit tests, and build stages to a Jenkinsfile is a crucial step in setting up a comprehensive CI/CD pipeline. Below is an example of how you can structure a Jenkinsfile to achieve these tasks:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code from version control
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Build your project (compile, package, etc.)
                sh 'mvn clean package' // Replace with your build command
            }
        }

        stage('Unit Tests') {
            steps {
                // Run unit tests
                sh 'mvn test' // Replace with your unit test command
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Execute SonarQube analysis using the SonarQube Scanner
                withSonarQubeEnv('SonarQubeServer') {
                    sh 'mvn sonar:sonar' // Replace with your SonarQube analysis command
                }
            }
        }

        stage('Deploy') {
            steps {
                // Deploy your application (if applicable)
                // sh '...'
            }
        }
    }

    post {
        success {
            // This block executes if the pipeline succeeds
            echo 'Pipeline succeeded!'
        }

        failure {
            // This block executes if the pipeline fails
            echo 'Pipeline failed!'
        }
    }
}
```

In this example Jenkinsfile:

- The pipeline is defined with several stages: Checkout, Build, Unit Tests, SonarQube Analysis, and Deploy.
- Each stage contains steps that perform specific tasks.
- The `checkout scm` step checks out your source code from the version control system.
- The `sh` steps run shell commands. Replace them with your build, test, and deployment commands.
- The `withSonarQubeEnv` block is used to set up the environment for SonarQube analysis. You need to replace `'SonarQubeServer'` with the configured SonarQube server ID in your Jenkins configuration.
- The `post` section defines actions to perform after the pipeline stages are completed. In this example, there are success and failure blocks that simply echo messages.

Remember to adapt the commands, paths, and configurations to match your project's structure and requirements. Additionally, you'll need to ensure that you have the necessary plugins installed in Jenkins to support Maven, SonarQube, and any other tools you're using in your pipeline.