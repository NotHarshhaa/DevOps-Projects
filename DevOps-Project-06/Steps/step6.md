# Step-06: Configure GitHub Webhook Trigger for Multibranch Pipeline in Jenkins

By setting up the **Multibranch Scan Webhook Trigger** plugin along with GitHub webhooks, you can automatically trigger Jenkins builds when code changes occur—without relying solely on periodic scans.

---

## 🔌 1. Install Required Plugin

Ensure you have installed:

### 📦 **Multibranch Scan Webhook Trigger Plugin**

- Go to **Manage Jenkins > Manage Plugins > Available**.
- Search for **"Multibranch Scan Webhook Trigger"**.
- Install the plugin and **restart Jenkins** if prompted.

---

## 🌐 2. Configure GitHub Webhook

Set up a webhook in your GitHub repository to notify Jenkins about changes.

- Open your GitHub repository.
- Navigate to **Settings > Webhooks > Add webhook**.
- Fill in:
  - **Payload URL:**  

    ```
    https://<your-jenkins-domain>/github-webhook/
    ```

    *(Ensure your Jenkins server is publicly reachable if needed.)*
  - **Content Type:**  

    ```
    application/json
    ```

  - **Events to Trigger:**  
    - Recommended: **"Just the push event"**  
    - Optionally: **"Pull requests"** (if you want builds for PRs too)
  - **Secret:** (optional) — For added security, configure a webhook secret and validate it in Jenkins.

- Click **"Add webhook"**.

> 🚨 Make sure Jenkins has the **GitHub plugin** installed to properly receive GitHub webhooks.

---

## 🏗 3. Configure Your Multibranch Pipeline Job

Create or modify your Multibranch Pipeline job:

- From Jenkins dashboard, click **New Item** or open an existing Multibranch Pipeline.
- Under **Build Triggers**:
  - Enable **"Scan Multibranch Pipeline Triggers"**.
  - ✅ **Check**: **"Periodically if not otherwise run"**  
    - Set Interval: e.g., **1 minute** *(for fallback periodic scans)*
  - ✅ **Check**: **"Build whenever a webhook is received"**  
    (Option enabled by the Multibranch Scan Webhook Trigger plugin)

- Under **Branch Sources**:
  - Confirm that your GitHub credentials and repo URL are correctly set.

---

## 💾 4. Save the Job Configuration

Click **"Save"** to apply the settings.

Jenkins will now respond to GitHub webhooks for this job.

---

## 🔥 5. Test the Webhook Trigger

- Make a change in your repository (e.g., update a `README.md` file).
- Push the change to GitHub.
- Check:
  - In GitHub: **Webhooks > Recent Deliveries** should show a `200 OK` response from Jenkins.
  - In Jenkins: The Multibranch Pipeline job should detect the change and automatically trigger a new build for the affected branch.

---

## 📄 6. Monitor Build Logs

- Open your Multibranch Pipeline project in Jenkins.
- Check the build logs and console output for your triggered branch.
- Validate that the webhook trigger worked correctly.

---

✅ **Result:**  
Now Jenkins automatically reacts to GitHub push and PR events, triggering builds without relying only on periodic polling—optimizing both resource usage and build responsiveness for a better CI/CD workflow.
