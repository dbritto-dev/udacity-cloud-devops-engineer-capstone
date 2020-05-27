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

        stage('Tests') {
            steps {
                sh 'make build-ci'
                sh 'echo "General Testing"'
                sh 'make test'
                sh 'echo "Performance Testing"'
                sh 'make performance-test'
            }
        }

        stage('Tests Artifacts') {
            steps {
                sh 'make test-artifacts'
            }
        }

        stage('Build') {
            steps {
                sh 'make build'
            }
        }

        stage('Publish') {
            steps {
                sh 'make publish'
            }
        }

        stage('Deploy') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    sh 'make deploy'
                }
            }
        }
    }
}
