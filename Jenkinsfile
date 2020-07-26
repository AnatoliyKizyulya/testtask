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
        stage ('Helm deploy'){
            steps {
                script{
                    def minikubeip = sh(script: 'minikube ip', returnStdout: true).trim()
                    sh """
                    helm upgrade --wait --install ping-helm ping-deploy/ --set image.tag=$BUILD_NUMBER,minikubeip=${minikubeip} --create-namespace -n test
                    helm list -A
                    """
                    def check = sh(script: "curl -s test-ping-app.${minikubeip}.nip.io/ping", returnStdout: true).trim()
                    if (check ==~ 'pong'){
                        echo "Test complete succesful, deploy app to prod"
                        sh """
                        helm upgrade --wait --install ping-helm ping-deploy/ --set image.tag=$BUILD_NUMBER,minikubeip=${minikubeip} --create-namespace -n prod
                        helm list -A
                        """
                    }else {
                        echo "Test failed, rollback to prevision version"
                        sh """
                        helm rollback ping-helm -n test
                        helm list -A
                        """
                    }
                }
            }
        }
    }
}

