pipeline {
    agent any

    environment {
        DOCKER_USER = credentials('docker-user')
        DOCKER_PASSWORD = credentials('docker-password')
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
                sh 'make deploy'
            }
        }
    }
}
