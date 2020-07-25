pipeline {
  agent any
  stages {
    stage('start minikube') {
      steps {
        sh '''echo "Change_id is: $BUILD_NUMBER"






whoami
minikube start --driver=docker --insecure-registry "10.0.0.0/8"
kubectl get po -A
echo "End test"'''
      }
    }

  }
}