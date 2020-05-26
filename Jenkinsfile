pipeline {
    agent any

    environment {
        DOCKER_USER = credentials('docker-user')
        DOCKER_PASSWORD = credentials('docker-password')
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
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    sh 'kubectl apply -f ./infra/k8s/deployments/blue.yaml --kubeconfig=$K8S_CONFIG_FILE'
                    sh 'kubectl apply -f ./infra/k8s/services/blue.yaml --kubeconfig=$K8S_CONFIG_FILE'
                }
            }
        }
    }
}
