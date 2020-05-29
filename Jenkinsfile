pipeline {
    agent any

    environment {
        DOCKER_USER = credentials('docker-user')
        DOCKER_PASSWORD = credentials('docker-password')
        K8S_CONFIG_FILE = credentials('k8s-config-file')
        ROLE = 'blue'
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    docker.build('minorpatch/capstone-flask:ci', '-f ./infra/docker/$ROLE/flask/ci/Dockerfile .')
                }
            }
        }

        stage('Linting') {
            steps {
                sh 'make lint'
            }
        }

        stage('Testing') {
            stages {
                stage('Security Testing') {
                    steps {
                        aquaMicroscanner imageName: 'alpine:latest', notCompliesCmd: 'exit 1', onDisallowed: 'fail', outputFormat: 'html'
                    }
                }

                stage('General Testing') {
                    steps {
                        sh 'make test'
                    }
                }

                stage('Performance Testing') {
                    steps {
                        sh 'make performance-test'
                    }
                }

                stage('Testing Artifacts') {
                    steps {
                        sh 'make test-artifacts'
                    }
                }
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

    post {
        always {
            archiveArtifacts artifacts: 'reports/web/**/*', allowEmptyArchive: true, fingerprint: true
            junit 'reports/junit/**/*.xml'
        }
    }
}
