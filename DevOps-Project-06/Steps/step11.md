# Step 11: Deploy Docker Image to EKS Cluster from JFrog Artifactory Using Jenkins

## **Step 1: Create Kubernetes Secret for Docker Registry Credentials**

Before pulling Docker images from JFrog Artifactory, you'll need to store your credentials in a Kubernetes secret. This allows Kubernetes to authenticate to the Artifactory registry when pulling the image.

1.1 Run the following command to create the secret, replacing `your-registry-username`, `your-registry-password`, and `<ARTIFACTORY_REGISTRY_URL>` with your actual registry credentials and URL:

```bash
kubectl create secret docker-registry artifactory-registry-secret \
  --docker-server=<ARTIFACTORY_REGISTRY_URL> \
  --docker-username=your-registry-username \
  --docker-password=your-registry-password \
  --namespace=your-namespace
```

This command creates a Kubernetes secret named `artifactory-registry-secret` that stores your Docker registry credentials.

---

## **Step 2: Define Kubernetes Deployment YAML**

Create a Kubernetes deployment YAML file that defines your application’s deployment and includes the Docker image from JFrog Artifactory.

2.1 Create a file named `your-deployment.yaml` and define the deployment:

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

2.2 Make sure to replace placeholders:

- `<ARTIFACTORY_REGISTRY_URL>`: Your Artifactory registry URL.
- `your-image:tag`: The Docker image and tag you want to use (e.g., `myapp:v1`).
- `your-deployment`: The name of your deployment.
- `your-namespace`: Your Kubernetes namespace.
- `your-app`: The label for your app.

This YAML configuration tells Kubernetes how to deploy your application with the specified Docker image, including pulling the image securely from the Artifactory registry using the secret.

---

## **Step 3: Define Kubernetes Service YAML**

Next, create a service to expose your deployment.

3.1 Create a file named `your-service.yaml` and define the service:

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

3.2 Replace placeholders:

- `your-service`: The name of your service.
- `your-namespace`: Your Kubernetes namespace.
- `your-app`: The label used in the deployment (to match the service to the deployment).

This YAML exposes your application on port 80 with a LoadBalancer service type.

---

## **Step 4: Configure Jenkins Deployment Stage**

Now, you'll need to automate the deployment process in Jenkins. Add a stage to your Jenkinsfile to deploy the Kubernetes resources.

4.1 Add the following code to your Jenkinsfile, inside the `stages` block:

```groovy
stage('Deploy to EKS') {
    steps {
        sh 'kubectl apply -f your-deployment.yaml -f your-service.yaml'
    }
}
```

This stage tells Jenkins to apply the deployment and service YAML files to your EKS cluster, thus deploying your application.

---

## **Step 5: Replace Placeholders**

Be sure to replace the following placeholders with the actual values for your setup:

- `<ARTIFACTORY_REGISTRY_URL>`: The URL of your JFrog Artifactory registry.
- `your-registry-username`: Your Artifactory Docker registry username.
- `your-registry-password`: Your Artifactory Docker registry password.
- `your-deployment.yaml`: The filename of your Kubernetes deployment YAML.
- `your-service.yaml`: The filename of your Kubernetes service YAML.
- `your-namespace`: The Kubernetes namespace you are working with.
- `your-app`: The app name or label used in both the deployment and service files.
- `your-image:tag`: The Docker image and tag to pull from Artifactory.

---

## **Step 6: Apply and Verify**

6.1 Apply the deployment and service to your EKS cluster:

```bash
kubectl apply -f your-deployment.yaml -f your-service.yaml
```

6.2 Verify the deployment and service are running correctly:

```bash
kubectl get deployments -n your-namespace
kubectl get services -n your-namespace
```

6.3 Check the logs or pod status to ensure everything is working as expected:

```bash
kubectl logs -f <pod-name> -n your-namespace
```

---

By following these steps, you’ll have a Kubernetes deployment in your EKS cluster that pulls a Docker image from JFrog Artifactory and exposes the app via a LoadBalancer service. Additionally, the deployment is automated in your Jenkins pipeline.
