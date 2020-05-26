pipeline {
    agent any

    environment {
        DOCKER_USER = credentials('docker-user')
        DOCKER_PASSWORD = credentials('docker-password')
        // K8S_API_SERVER = credentials('k8s-api-server')
        // K8S_TOKEN = credentials('k8s-token')
        K8S_CONFIG_FILE = credentials('k8s-config-file')
    }

    stages {
        stage('Linting') {
            steps {
                sh 'make lint'
            }
        }

        stage('Build') {
            steps {
                sh 'echo "build"'
            }
        }

        stage('Publish') {
            steps {
                sh 'echo "publish"'
            }
        }

        stage('Deploy') {
            steps {
                // sh 'aws eks get-token --cluster-name=capstone-cluster'
                sh 'echo $K8S_CONFIG_FILE'
                sh 'kubectl version --kubeconfig $K8S_CONFI_FILE'
            }
        }
    }
}
