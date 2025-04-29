# Step-04: Add Jenkins Agent Credentials to Master

To enable secure communication between the Jenkins Master and Agent nodes, you'll need to **add credentials in the Jenkins Master** that Agents will use to authenticate. This is typically done via **SSH key pairs** or **secret tokens**.

---

## 🔐 1. Log In to Jenkins Master

Open your browser and navigate to your Jenkins Master instance:

```
http://<jenkins-master-ip>:8080
```

Log in using your admin credentials.

---

## 🔧 2. Navigate to Credentials Configuration

- From the Jenkins dashboard, click on **"Manage Jenkins"**.
- Then select **"Manage Credentials"** from the list.

---

## ➕ 3. Add New Credentials

- Click on **"(global)"** under "Stores scoped to Jenkins" > "System".
- Click on **"Add Credentials"** from the sidebar.

---

## 🗂 4. Select Credential Type

In the "Kind" dropdown, choose one of the following based on your setup:

### Option A: **SSH Username with Private Key**

Use this if you connect to agents using SSH key authentication.

- **Username:** e.g., `jenkins`
- **Private Key:** Choose "Enter directly" and paste the private key content (usually from `~/.ssh/id_rsa`)
- **Passphrase:** Leave blank if not used.
- **ID (optional):** e.g., `jenkins-agent-ssh`
- **Description:** e.g., `SSH Key for Jenkins Agent`

### Option B: **Secret Text**

Use this if you're using a token or password for agent authentication.

- **Secret:** Paste the token or password.
- **ID (optional):** e.g., `agent-token`
- **Description:** e.g., `Agent Token for API Connection`

---

## 💾 5. Save Credentials

Click **"OK"** or **"Save"** to store the credentials. They are now available system-wide.

---

## 🛠 6. Prepare Agent Node

- If using SSH keys, make sure the **public key** is added to the Agent node’s:

  ```bash
  ~/.ssh/authorized_keys
  ```

- Ensure proper permissions on the `.ssh` directory and files:

  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/authorized_keys
  ```

---

## 🧩 7. Connect Agent Node with Credentials

- Go to **"Manage Jenkins" > "Manage Nodes and Clouds"**.
- Click **"New Node"** or edit an existing one.
- Set:
  - **Remote root directory** (e.g., `/home/jenkins`)
  - **Labels** (e.g., `maven-build`)
  - **Launch method:** Choose `Launch agents via SSH`.
  - In **"Host"**, specify the agent's IP or hostname.
  - Under **"Credentials"**, select the one you added earlier.

---

## 💡 8. Finalize and Save

Click **"Save"**. Jenkins Master will now use the selected credentials to establish a secure connection with the Agent node.

Once connected successfully, the Agent will appear as **online** and ready to run jobs.
