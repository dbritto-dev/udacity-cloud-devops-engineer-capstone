pipeline {
  agent any
  stages {
    stage('Build') {
        steps {
            sh 'python3 -m venv ~/.devops'
            sh """
                . ~/.devops/bin/activate
                pip install -r ./etc/docker/flask/requirements-ci.txt
            """
        }
    }

    stage('Linting') {
        steps {
            sh '. ~/.devops/bin/activate'
            sh 'make lint'
        }
    }

    stage('Testing') {
        steps {
            sh 'source ~/.devops/bin/activate'
            sh 'make test'
            aquaMicroscanner imageName: 'alpine:latest', notCompleted: 'exit 1', onDisallowed: 'fail'
        }
    }

    stage('Deploy') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-static', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
            sh """
                mkdir -p ~/.aws
                echo "[default]" >~/.aws/credentials
                echo "[default]" >~/.boto
                echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >>~/.boto
                echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}">>~/.boto
                echo "aws_access_key_id = ${AWS_ACCESS_KEY_ID}" >>~/.aws/credentials
                echo "aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}">>~/.aws/credentials
            """
        }
        ansiblePlaybook playbook: 'infra/main.yml', inventory: 'infra/inventory'
      }
    }
  }
}
