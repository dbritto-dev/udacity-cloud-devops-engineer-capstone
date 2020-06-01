pipeline {
    agent any

    environment {
        APP_NANE = "capstone"
        K8S_CONFIG_FILE = credentials('k8s-config-file')
        ROLE = 'blue'

        DOCKER_USER = "minorpatch"
        NGINX_IMAGE = "${DOCKER_USER}/${APP_NAME}-nginx:${ROLE}"
        FLASK_IMAGE = "${DOCKER_USER}/${APP_NAME}-flask:${ROLE}"
        CI_IMAGE = "${DOCKER_USER}/${APP_NAME}-flask:ci"
    }

    stages {
        stage('Setup') {
            steps {
                script {
                    docker.build("${CI_IMAGE}", "-f ./infra/docker/${ROLE}/flask/ci/Dockerfile .")
                }
            }
        }

        stage('Linting') {
            steps {
                script {
                    docker.image("${CI_IMAGE}").withRun { c ->
                        sh "docker exec -i ${c.id} python -m flake8 ."
                    }
                }
            }
        }

        stage('Testing') {
            stages {
                stage('Security Testing') {
                    steps {
                        aquaMicroscanner imageName: "alpine:latest", notCompliesCmd: "exit 1", onDisallowed: "fail", outputFormat: "html"
                    }
                }

                stage('General Testing') {
                    steps {
                        script {
                            docker.image("${CI_IMAGE}").withRun { c ->
                                sh "docker exec -i ${c.id} python -m pytest -vv"
                            }
                        }
                    }
                }

                stage('Performance Testing') {
                    steps {
                        script {
                            docker.image("${CI_IMAGE}").withRun { c ->
                                sh "docker exec -i ${c.id} python -m locust -H http://127.0.0.1:8080 -f ./tests/performance.py --headless --print-stats --only-summary -u 100 -r 1 -t 1m"
                            }
                        }
                    }
                }

                stage('Testing Artifacts') {
                    steps {
                        script {
                            docker.image("${CI_IMAGE}").withRun { c ->
                                sh "docker exec -i ${c.id} python -m coverage run -m pytest --junitxml=reports/junit/junit.xml"
                                sh "docker exec -i ${c.id} python -m coverage html -d reports/web"
                                sh "docker cp ${c.id}:/app/reports ./reports"
                            }
                        }
                    }
                }
            }
        }


        stage('Build') {
            steps {
                script {
                    docker.build("${NGINX_IMAGE}", "-f ./infra/docker/${ROLE}/nginx/Dockerfile .")
                    docker.build("${FLASK_IMAGE}", "-f ./infra/docker/${ROLE}/flask/Dockerfile .")
                }
            }
        }

        stage('Publish') {
            steps {
                script {
                    docker.image("${NGINX_IMAGE}").push()
                    docker.image("${FLASK_IMAGE}").push()
                }
            }
        }

        stage('Deploy') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                    sh """
                    kubectl apply --kubeconfig=${K8S_CONFIG_FILE} -f ./infra/k8s/${ROLE}
                    """
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: "reports/web/**/*", allowEmptyArchive: true, fingerprint: true
            junit "reports/junit/**/*.xml"
        }
    }
}
