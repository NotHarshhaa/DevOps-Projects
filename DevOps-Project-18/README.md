# Spring Boot CI/CD Pipeline with Jenkins, Docker, Helm & AKS

## Overview

This project implements an end-to-end CI/CD pipeline for a Spring Boot application using:

- GitHub
- Jenkins
- Maven
- Docker
- Docker Hub
- Helm
- Kubernetes
- Azure Kubernetes Service (AKS)

The pipeline automatically builds the application, creates and publishes a Docker image, deploys the corresponding image version to AKS using Helm, and verifies the Kubernetes rollout.

---

## Architecture

```text
                    GitHub
                       |
                       | SCM Polling
                       v
                  +---------+
                  | Jenkins |
                  | Azure VM|
                  +----+----+
                       |
              +--------+--------+
              |                 |
              v                 v
          Maven Build      Docker Build
              |                 |
              v                 v
          Spring Boot      Docker Image
              JAR          :BUILD_NUMBER
                                |
                                v
                         +-------------+
                         | Docker Hub  |
                         +------+------+
                                |
                                v
                             Helm
                                |
                                v
                         +-------------+
                         |     AKS     |
                         |  project18  |
                         +------+------+
                                |
                         +------+------+
                         |             |
                         v             v
                       Pod           Pod