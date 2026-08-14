FROM tushar-maven-docker-agent:1

USER root

RUN apt-get update && \
    apt-get install -y curl ca-certificates && \
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

RUN mvn --version && \
    docker --version && \
    helm version && \
    kubectl version --client