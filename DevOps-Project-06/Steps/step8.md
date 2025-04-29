# Step-08: JFrog Artifactory Integration with Jenkins

<details>
<summary><strong>1. Add JFrog Credentials to Jenkins</strong></summary>

<br/>

1. **Log in to Jenkins:**  
   Log in to your Jenkins Master's web interface.

2. **Access Credentials:**  
   ➔ "Manage Jenkins" ➔ "Manage Credentials."

3. **Add Credentials:**  
   - Click on the "Global" domain (or your desired domain).
   - Then click "Add Credentials" from the left-hand side menu.

4. **Choose Credentials Kind:**  
   - Select "Secret text" as the kind.

5. **Fill in Credential Details:**  
   - **Secret:** Enter your JFrog Artifactory API key or access token.  
   - **ID:** Provide a unique ID for these credentials.  
   - **Description (Optional):** Add a description to easily identify them later.

6. **Save Credentials:**  
   Click "OK" or "Save" to store the credentials.

The credentials are now available for use in Jenkins jobs and system configuration!

</details>

---

<details>
<summary><strong>2. Install and Configure JFrog Artifactory Plugin</strong></summary>

<br/>

### Install the Plugin:

1. **Access Plugin Manager:**  
   ➔ "Manage Jenkins" ➔ "Manage Plugins" ➔ "Available" tab.

2. **Search and Install:**  
   - Search for **"JFrog Artifactory"** plugin.
   - Install it by selecting and clicking "Install without restart."

---

### Configure Artifactory Server:

1. **Open Configure System:**  
   ➔ "Manage Jenkins" ➔ "Configure System."

2. **Add Artifactory Server:**  
   - Scroll down to the **Artifactory** section.
   - Click "Add Artifactory Server."

3. **Provide Server Details:**  
   - **Name:** Give a friendly name.  
   - **URL:** Enter your JFrog Artifactory instance URL.  
   - **Credentials:** Select the credentials you created earlier.

4. **Advanced Settings (Optional):**  
   Configure optional fields like:
   - Repository keys
   - Timeout settings
   - Connection retries
   - Proxy settings

5. **Test Connection:**  
   (Optional) Test the connection to validate the server setup.

6. **Save Configuration:**  
   Click "Save" or "Apply" to finish configuration.

</details>

---

<details>
<summary><strong>3. Using JFrog Artifactory in Jenkins Jobs</strong></summary>

<br/>

Once everything is installed and configured:

- You can now **upload** and **download** artifacts between Jenkins and Artifactory in your pipelines.
  
---

### Example Usage in Jenkinsfile:

- **Generic Upload Step:**

  ```groovy
  rtUpload (
      serverId: 'your-artifactory-server-name',
      spec: '''{
          "files": [
              {
                  "pattern": "build/libs/*.jar",
                  "target": "libs-release-local/"
              }
          ]
      }'''
  )
  ```

- **Generic Download Step:**

  ```groovy
  rtDownload (
      serverId: 'your-artifactory-server-name',
      spec: '''{
          "files": [
              {
                  "pattern": "libs-release-local/*.jar",
                  "target": "downloaded/"
              }
          ]
      }'''
  )
  ```

---

### Tips:

- Always adapt your Jenkins jobs and `Jenkinsfile` to match your organization's build and deployment processes.
- You can integrate with Freestyle Jobs or Pipeline (preferred for flexibility).

</details>
