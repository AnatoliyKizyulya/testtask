pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                echo "Change_id is: $BUILD_NUMBER"
                sh """
                minikube start --driver=docker --insecure-registry "10.0.0.0/8"
                minikube addons enable registry
                minikube addons enable ingress
                """
            }

            post {
                success {
                    echo "Congrat"
                    sh 'echo Minikube ip: $(minikube ip)'
                }
                failure {
                    echo "Minikube does not start"
                }
            }
        }
        stage ('Build'){
            steps {
                git 'https://github.com/AnatoliyKizyulya/testtask.git'
                sh """
                eval \$(minikube docker-env)
                docker build --tag ping_pipe:$BUILD_NUMBER .
                """
            }
        }
        stage ('Helm deploy to test'){
            steps {
                sh """
                helm install ping-helm ping-deploy/ --set image.tag=$BUILD_NUMBER --dry-run
                """
            }
        }
    }
}
