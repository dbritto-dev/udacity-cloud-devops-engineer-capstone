pipeline {
    agent any

    environment {
        DOCKER_USER = credentials('docker-user')
        DOCKER_PASSWORD = credentials('docker-password')
        // K8S_API_SERVER = credentials('k8s-api-server')
        // K8S_TOKEN = credentials('k8s-token')
        // K8S_CONFIG = credentials('k8s-config')
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
                    // sh 'aws eks get-token --cluster-name=capstone-cluster'
                    sh 'echo ~/.kube/config'
                    sh 'kubectl version --kubeconfig=/home/ubuntu/.kube/config'
                }
            }
        }
    }
}
