FROM eclipse-temurin:17-jdk-jammy

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        maven \
        docker.io \
        curl \
        ca-certificates \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install kubectl
RUN curl -fsSL -o /usr/local/bin/kubectl \
    https://dl.k8s.io/release/$(curl -fsSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Verify tools
RUN mvn --version && \
    docker --version && \
    helm version && \
    kubectl version --client