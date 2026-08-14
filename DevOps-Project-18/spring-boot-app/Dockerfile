FROM maven:3.9-eclipse-temurin-17

USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io curl && \
    rm -rf /var/lib/apt/lists/*

# Install Helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN mvn -version
RUN docker --version
RUN helm version