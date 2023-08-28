# About Step-11

To pull a Docker image from JFrog Artifactory, deploy it to an Amazon EKS cluster using Kubernetes deployment resources, expose it with a service resource, and add this deployment stage to a Jenkinsfile, you can follow these steps:

1. **Create Kubernetes Secret for Docker Registry Credentials:**
   First, you need to create a Kubernetes secret that holds your JFrog Artifactory Docker registry credentials. Replace `your-registry-username` and `your-registry-password` with your actual credentials:

   ```bash
   kubectl create secret docker-registry artifactory-registry-secret \
     --docker-server=<ARTIFACTORY_REGISTRY_URL> \
     --docker-username=your-registry-username \
     --docker-password=your-registry-password \
     --namespace=your-namespace
   ```

2. **Define Kubernetes Deployment YAML:**
   Create a Kubernetes deployment YAML file (`your-deployment.yaml`) that specifies the Docker image from JFrog Artifactory and other deployment settings. Replace placeholders with your actual values:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: your-deployment
     namespace: your-namespace
   spec:
     replicas: 3
     selector:
       matchLabels:
         app: your-app
     template:
       metadata:
         labels:
           app: your-app
       spec:
         containers:
           - name: your-container
             image: <ARTIFACTORY_REGISTRY_URL>/your-image:tag
             ports:
               - containerPort: 80
         imagePullSecrets:
           - name: artifactory-registry-secret
   ```

3. **Define Kubernetes Service YAML:**
   Create a Kubernetes service YAML file (`your-service.yaml`) that exposes your deployment:

   ```yaml
   apiVersion: v1
   kind: Service
   metadata:
     name: your-service
     namespace: your-namespace
   spec:
     selector:
       app: your-app
     ports:
       - protocol: TCP
         port: 80
         targetPort: 80
     type: LoadBalancer
   ```

4. **Configure Jenkins Deployment Stage:**
   Add the following deployment stage to your Jenkinsfile:

   ```groovy
   stage('Deploy to EKS') {
       steps {
           sh 'kubectl apply -f your-deployment.yaml -f your-service.yaml'
       }
   }
   ```

Make sure you replace placeholders like `<ARTIFACTORY_REGISTRY_URL>`, `your-registry-username`, `your-registry-password`, `your-deployment.yaml`, `your-service.yaml`, `your-namespace`, `your-app`, and `your-image:tag` with actual values.

This setup assumes you have the necessary credentials and permissions to interact with your EKS cluster and JFrog Artifactory. Adapt the steps to match your specific environment and configurations.
