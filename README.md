# Project Overview

In this project, you will apply the skills you have acquired in this course to build a successfull
CI/CD workflow.

The app get world stats for covid 19 for each country in the world. This project use Python Flask app.

Visit the app on http://a8b4bd8db124d4b6c82d61b144c3b6e3-215389831.us-east-1.elb.amazonaws.com/

-   Endpoints:
    -   Hello World! -> http://a8b4bd8db124d4b6c82d61b144c3b6e3-215389831.us-east-1.elb.amazonaws.com/
    -   World Covid Stats -> http://a8b4bd8db124d4b6c82d61b144c3b6e3-215389831.us-east-1.elb.amazonaws.com/world-stats

## Project Tasks

-   Setup `Jenkins` to deploy `Kubernetes` apps on `Amazon EKS`.
-   Use `Docker` to containerized the application.
-   Use `Kubernetes` to Orchestrated the application.
-   Use `Jenkins` to `Linting`, `Testing`, and `Building` the application.
-   Use `Jenkins` to automate the `Blue-Green Deployment`.

---

## Setup Environment

### Kubernetes Steps

-   Setup and configure IAM Roles (https://docs.aws.amazon.com/eks/latest/userguide/security_iam_service-with-iam.html)
-   Setup and configure AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
-   Setup and configure Docker (https://docs.docker.com/engine/install/)
-   setup and configure Kubernetes (https://kubernetes.io/es/docs/tasks/tools/install-kubectl/)
-   Setup EKSCTL (https://eksctl.io/introduction/#installation)
-   Setup Hadolint (https://github.com/hadolint/hadolint#install)

### Jenkins Steps

-   Setup and configure Aqua MicroScanner (https://plugins.jenkins.io/aqua-microscanner/)
-   Setup Pipeline AWS (https://plugins.jenkins.io/pipeline-aws/)
-   Setup BlueOcean (https://plugins.jenkins.io/blueocean/) and (https://plugins.jenkins.io/blueocean-executor-info/)
-   Create Credentials:
    -   Secret Texts
        -   Docker User -> `ID`: docker-user, `Secret`: <your-docker-user>
        -   Docker Password -> `ID`: docker-password, `Secret`: <your-docker-password>
        -   K8S Config File Path -> `ID`: k8s-config-file, `Secret`: /home/ubuntu/.kube/kubeconfig (an example)
    -   AWS Credentials
        -   AWS Credentials -> `ID`: aws-creds, `Access Key ID`: <access-key-id>, `Secret Access Key`: <secret-access-key>

### Create a cluster

```
$ eksctl create cluster -f ./infra/server.yaml
```

### Running the app

```sh
$ kubectl apply -f ./infra/k8s/deployments/<stage>.yaml
$ kubectl apply -f ./infra/k8s/services/<stage>.yaml
```

e.g: stage -> blue

```
$ kubectl apply -f ./infra/k8s/deployments/blue.yaml
$ kubectl apply -f ./infra/k8s/services/blue.yaml
```

> Note: The <stage> can be `blue` or `green` for Blue-Green Deployments.

### GitOps

To trigger updates push your changes to the right branch.
