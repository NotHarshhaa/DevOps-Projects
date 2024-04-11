# About Step-04

To establish a connection between the Jenkins Master and Agent nodes, you need to add credentials to Jenkins that will be used by the Agent to authenticate and connect to the Master. Here's how you can add Jenkins Agent node's credentials in Jenkins Master:

1. **Login to Jenkins Master:**
   Open your web browser and navigate to the Jenkins Master's web interface.

2. **Access Credentials:**
   Click on "Manage Jenkins" from the home page, and then select "Manage Credentials" from the dropdown.

3. **Add Credentials:**
   Click on the "Global" domain (or any other domain you prefer) and then click on "Add Credentials" from the left-hand side menu.

4. **Choose Credentials Kind:**
   In the "Add Credentials" page, you will see a dropdown to select the kind of credentials you want to add. Since you want to add credentials for a Jenkins Agent node, you will typically choose "SSH Username with private key" or "Secret text" based on your authentication method.

   - **SSH Username with private key:** If you're using SSH key pair authentication, choose this option. Provide the SSH private key and username for the Agent node.
   - **Secret text:** If you have a secret token or password for authentication, choose this option.

5. **Fill in Details:**
   Depending on the option you chose, fill in the required fields. For SSH Username with private key, you'll provide the private key, and for Secret text, you'll provide the secret token or password.

6. **Add Description:**
   Optionally, you can add a description to help you identify this credential entry later.

7. **Save Credentials:**
   Click the "OK" or "Save" button to save the credentials. They will now be available for use in Jenkins.

8. **Configure Agent Node:**
   To establish a connection between the Jenkins Master and the Agent node using the added credentials, you'll need to configure the agent node with the same credentials. 

   - If you're using the SSH key-based method, ensure that the SSH key pair (public key) corresponding to the private key you added in the credentials is added to the `.ssh/authorized_keys` file on the Agent node.

9. **Add Agent Node in Jenkins:**
   After adding credentials, you'll need to create or configure an agent node on Jenkins to use these credentials for authentication when connecting to the master. During the agent configuration, you'll be prompted to select the credentials you added.

   - Navigate to "Manage Jenkins" > "Manage Nodes and Clouds" > "New Node" (or edit an existing node).
   - In the "Launch method" section, select "Launch agent by connecting it to the master" and then choose the credentials you added from the dropdown.

10. **Save Configuration:**
    Finish configuring the agent node as needed and save the configuration.

Now, when the Jenkins Master tries to connect to the Agent node, it will use the credentials you added to authenticate and establish a connection. This allows the Jenkins Master to dispatch builds and tasks to the Agent node for execution.