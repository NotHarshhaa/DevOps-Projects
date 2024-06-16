# Kubernetes

Deployment into Kubernetes is simple using a [generic Helm chart for deploying web apps](https://github.com/benc-uk/helm-charts/tree/master/webapp)

Make sure you have [Helm installed first](https://helm.sh/docs/intro/install/)

First add the Helm repo
```bash
helm repo add benc-uk https://benc-uk.github.io/helm-charts
```

Make a copy of `app.sample.yaml` to `myapp.yaml` and modify the values to suit your environment. If you're in a real hurry you can use the file as is and make no changes.
```bash
helm install demo benc-uk/webapp --values myapp.yaml
```