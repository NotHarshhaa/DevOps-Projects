# About Step-05

Adding GitHub credentials to Jenkins allows your Jenkins jobs to interact with your GitHub repositories, enabling tasks like cloning repositories, fetching code, and triggering builds based on changes. Here's how you can add GitHub credentials and create a Multibranch Pipeline job in Jenkins:

1. **Login to Jenkins Master:**
   Open your web browser and log in to the Jenkins Master's web interface.

2. **Access Credentials:**
   Click on "Manage Jenkins" from the home page, and then select "Manage Credentials" from the dropdown.

3. **Add GitHub Credentials:**
   Click on the "Global" domain (or any other domain you prefer) and then click on "Add Credentials" from the left-hand side menu.

4. **Choose Credentials Kind:**
   In the "Add Credentials" page, select "Username with password". This option is appropriate for GitHub API token-based authentication.

5. **Fill in Details:**
   - Username: Your GitHub username.
   - Password: Generate a personal access token in your GitHub account settings (Settings > Developer settings > Personal access tokens) with the necessary scopes (e.g., repo, read:user) for your Jenkins use case. Enter this token as the password.
   - ID: A unique identifier for these credentials.

6. **Add Description (Optional):**
   Optionally, add a description to help you identify these credentials later.

7. **Save Credentials:**
   Click the "OK" or "Save" button to save the credentials. They will now be available for use in Jenkins.

8. **Create a Multibranch Pipeline Job:**

   - From the Jenkins dashboard, click "New Item".
   - Enter a name for your job and choose "Multibranch Pipeline".
   - Click "OK".

9. **Configure the Multibranch Pipeline:**

   - In the "Branch Sources" section, add a new "GitHub" source.
   - Provide the GitHub repository URL and credentials you added in the previous steps.
   - Configure other options such as discovery behavior and build strategies according to your needs.

10. **Save Configuration:**
    Click "Save" to create the Multibranch Pipeline job.

11. **Automatic Branch Discovery:**
    The Multibranch Pipeline job will automatically discover branches and pull requests in your GitHub repository and create corresponding Jenkins pipeline projects for each branch or pull request.

12. **Pipeline Configuration:**
    In each discovered pipeline project, you can create a `Jenkinsfile` in the repository to define the build steps, tests, and deployment actions for that branch or pull request.

13. **Webhooks (Optional):**
    For better automation and triggering builds on new commits, consider configuring webhooks in your GitHub repository settings. Jenkins can listen to these webhooks and automatically trigger builds on code changes.

With these steps, you've added GitHub credentials to Jenkins and created a Multibranch Pipeline job that automatically discovers and builds branches and pull requests from your GitHub repository. This allows you to maintain a CI/CD workflow with automatic integration, testing, and deployment based on code changes.