# About Step-12

To add the Prometheus Helm chart repository and implement cluster monitoring using Prometheus and Grafana, follow these steps:

1. **Install Helm:**
   Make sure you have Helm installed on your local machine or the server where you're managing your Kubernetes cluster.

2. **Add Prometheus Helm Chart Repository:**
   Run the following command to add the official Prometheus Helm chart repository:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

3. **Install Prometheus and Grafana:**
   Deploy Prometheus and Grafana using Helm charts. Create a file named `values.yaml` to customize the configurations.

   ```bash
   helm install prometheus prometheus-community/prometheus -f values.yaml
   helm install grafana prometheus-community/grafana -f values.yaml
   ```

   In the `values.yaml` file, you can specify various configurations such as scrape targets, retention policies, and more. Here's an example of a `values.yaml` file for Prometheus:

   ```yaml
   server:
     global:
       scrape_interval: 15s
     scrape_interval: 15s
     scrape_timeout: 10s
     evaluation_interval: 15s

   alertmanager:
     enabled: false

   pushgateway:
     enabled: false
   ```

4. **Access Grafana:**
   After installing Grafana, you can access it using port-forwarding or by exposing it as a service.

   Port Forwarding:
   ```bash
   kubectl port-forward svc/grafana <local-port>:80
   ```

   Expose as Service (not recommended for production):
   ```bash
   kubectl expose svc/grafana --type=LoadBalancer --name=grafana-service
   ```

5. **Configure Data Source in Grafana:**
   Access Grafana in your browser using the provided URL and credentials. Configure Prometheus as a data source in Grafana:

   - Log in to Grafana.
   - Go to Configuration > Data Sources.
   - Click "Add data source."
   - Select "Prometheus" as the data source type.
   - Configure the URL to your Prometheus server (usually `http://prometheus-server`).
   - Click "Save & Test."

6. **Import Dashboards:**
   Grafana offers pre-configured dashboards for monitoring. You can import these dashboards or create your own.

   - Go to the Grafana dashboard.
   - Click the "+" icon on the left sidebar and select "Import."
   - Enter the dashboard ID or URL to import from the Grafana dashboard repository.

7. **Access Prometheus and Grafana:**
   Prometheus and Grafana should now be accessible using the URLs you set up or exposed. Use Grafana's dashboards to monitor your Kubernetes cluster.

Remember to adapt the configurations and options to your specific needs and security policies. This is a simplified guide, and there are more advanced configurations and security considerations for production environments.
