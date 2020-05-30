# Project Overview

This application simplies the access to the covid 19 stats of the world (stats for each country). 
This application is used to implement all the knowledge acquired on the Cloud DevOps Engineer
Nano Degree on Udacity. The app has a simple api with two endpoints, the app is built it on top of 
Python using `Flask` and `BeautifulSoup 4` (to scrape the data).

**API URL:** `<your-api-url>` (see the [Verifying](#verifying) section to get the url of your api).

| Endpoints | Path           | Description                                                                             |
| --------- | -------------- | --------------------------------------------------------------------------------------- |
| GET       | `/`            | Returns a `Hello World!` message with the current state of the app (`blue` or `green`). |
| GET       | `/world-stats` | Returns covid stats of the world.                                                       |

**PROJECT STRUCTURE**

| File Name 　　　　　　　　　　　　　　 | Description 　　　　　　　                                                     |
| :------------------------------------- | :-------------------------------------------------------------------- |
| `├── code/`                            | _This directory contains the Python Flask app and Tests_              |
| `　　├── capstone/`                     | Python Flask App.                                                     |
| `　　├── tests/`                        | Tests for the Python Flask App.                                       |
| `　　├── .coveragerc`                   | Python Coverage configuration file.                                   |
| `　　├── requirements-ci.txt`           | Python dependencies file for Continuous Integration (CI).             |
| `　　├── requirements-dev.txt`          | Python dependencies file for development.                             |
| `　　├── requirements.txt`              | Python dependencies file for production.                              |
| `　　├── run.py`                        | Python script to run the application.                                 |
| `　　└── tox.ini`                       | Flask8 configuration file.                                            |
| `├── infra/`                           | _This directory contains the files for docker and kubernetes._        |
| `　　├── docker/`                       | Docker files for blue and green images.                               |
| `　　├── k8s/`                          | Kubernetes files for blue and green deployments.                      |
| `　　└── server.yaml`                   | Template to create the cluster on Amazon EKS using EKSCTL.            |
| `├── nginx/`                           | _This directory contains the files for a custom NGINX configuration._ |
| `├── screenshots/`                     | _This directory contains the screenshots for the project validation._ |
| `├── .editorconfig`                    | Configuration file for editorconfig.                                  |
| `├── .gitignore`                       | Configuration file for gitignore.                                     |
| `├── Jenkinsfile`                      | Configuration file for Jenkins Pipelines.                             |
| `├── Makefile`                         | Set of custom scripts.                                                |
| `├── README.md`                        | Description of the app.                                               |
| `└── TODO.md`                          | Project TODO.                                                         |


# Pre-requisites

-   AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
-   AWS IAM Roles for EKS: https://docs.aws.amazon.com/eks/latest/userguide/security_iam_service-with-iam.html
-   Jenkins: https://www.jenkins.io/download/
-   Docker: https://docs.docker.com/engine/install/
-   Kubernetes: https://kubernetes.io/es/docs/tasks/tools/install-kubectl/
-   EKSCTL: https://eksctl.io/introduction/#installation

> **Note:** Jenkins needs Java to run. To install Java for jenkins run this 
> command: `sudo apt install default-jdk -y` (only Debian distros)


# Setup

### 1. Create the Cluster

To create a cluster you can use the following command.

```sh
$ eksctl create cluster -f ./infra/eks/cluster.yaml
```

> **Note:** You can create the cluster manually following this guide: 
> https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html

### 2. Create a Kubernetes config for Amazon EKS

To create/update a Kubernetes config (kubeconfig) you can use following command.

```sh
$ aws eks --region us-east-1 update-kubeconfig --name capstone-cluster
```

> **Note:** Read more about kubeconfig files for EKS on: https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html

### 3. Configure Jenkins

**Plugins**

-   AWS Pipeline: https://plugins.jenkins.io/pipeline-aws
-   Aqua MicroScanner: https://plugins.jenkins.io/aqua-microscanner/
-   BlueOcean: https://plugins.jenkins.io/blueocean/, https://plugins.jenkins.io/blueocean-executor-info/

**Credentials**

-   **Docker (Steps):** 
    1.  ➡️ Jenkins (Dashboard)
    2.  ➡️ Manage Jenkins
    3.  ➡️ Configure System
    4.  ➡️ Declarative Pipeline (Docker)
-   **Kubernetes Config File (Steps):**
    1.  ➡️ Jenkins (Dashboard)
    2.  ➡️ Job (github repo) 
    3.  ➡️ Credentials
    4.  ➡️ Store scoped to `<github-repo>`
    5.  ➡️ Global
    6.  ➡️ Add credentials
        -   **Kind:** `Secret Text`
        -   **ID:** `k8s-confige-file`
        -   **Secret:** `/path/to/your/kubeconfig-file` **(absolute paths)** e.g: `/home/ubuntu/.kube/kubeconfig`
-   **AWS (Steps):** 
    1.  ➡️ Jenkins (Dashboard)
    2.  ➡️ Job (github repo)
    3.  ➡️ Credentials
    4.  ➡️ Store scoped to `<github-repo>`
    5.  ➡️ Global
    6.  ➡️ Add credentials
        -   **Kind:** `AWS Credentials`
        -   **ID:** `aws-creds`
        -   Fill the other fields.

**Pipelines** 

To create a pipeline using `BlueOcean` follow this guide: https://www.jenkins.io/doc/book/blueocean/creating-pipelines/

# Deploying

**Automate deploys**

You can trigger the deployments just pushing update the right branch. If you want to a `blue deployment` push your
changes to the `blue branch`.

**Manual deploys**

You can trigger manual deploy using the following command: 

```
$ kubectl apply -f ./infra/k8s/deployments/blue.yaml
$ kubectl apply -f ./infra/k8s/services/blue.yaml
```
or

```sh
$ kubectl apply -f ./infra/k8s/deployments/blue.yaml -f ./infra/k8s/services/blue.yaml
```

> **Note:** This step require to access to your ec2 instance before. 
> Check the [Verifying](#verifying) section to get help.

# Verifying

### 1. Connect to the EC2 instance using ssh

To connect to your EC2 instance follow this guide: https://docs.aws.amazon.com/quickstarts/latest/vmlaunch/step-2-connect-to-instance.html

### 2. Get the link to the appplication

To get the external ip of our service you can use the following command:

```sh
$ kubectl get services -l app=capstone --output jsonpath='{.items[].status.loadBalancer.ingress[].hostname}'
```

With the link you can access to the app. If all is working yo can see a message like this:

```json
{"message":"Hello GREEN APP!"}
```
or
```json
{"message":"Hello BLUE APP!"}
```

# Thanks to

A big thanks to 

* Udacity
* Raul Hugo @RaulHugo
