pipeline {
  agent any

  environment {
    DOCKERHUB = credentials('dockerhub-creds')  // Jenkins credential ID (username + password)
    DOCKERHUB_USER = "jayantdanech"
    IMAGE_NAME = "devops-capstone-p1"
    REPO_URL = "https://github.com/jayantdanech/DevOpsProfessional.git"
    KUBECONFIG = credentials('kubeconfig-cred') // optional, if cluster access via kubeconfig
  }

  stages {

    stage('Checkout') {
      steps {
        echo "Checking out code from ${env.REPO_URL}"
        git branch: 'main', url: "${env.REPO_URL}"
      }
    }

    stage('Build & Push Docker Image') {
      steps {
        script {
          def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          sh """
            docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${shortCommit} .
            docker tag ${DOCKERHUB_USER}/${IMAGE_NAME}:${shortCommit} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
            echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin
            docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${shortCommit}
            docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest
          """
        }
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        script {
          // ensure kubectl can access the cluster
          withCredentials([file(credentialsId: 'kubeconfig-cred', variable: 'KUBECONFIG_FILE')]) {
            sh '''
              export KUBECONFIG=$KUBECONFIG_FILE
              IMAGE=${DOCKERHUB_USER}/${IMAGE_NAME}:latest

              # If deployment exists, update it; otherwise apply manifest
              kubectl set image deployment/devops-capstone app=$IMAGE --record || kubectl apply -f k8s-deployment.yml

              kubectl rollout status deployment/devops-capstone --timeout=120s

              # Basic health check (optional)
              kubectl port-forward svc/devops-capstone-svc 8085:80 >/tmp/pf.log 2>&1 &
              sleep 3
              curl -f http://localhost:8085 || (echo "Health check failed!" && exit 1)
              pkill -f "kubectl port-forward svc/devops-capstone-svc" || true
            '''
          }
        }
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline finished successfully. Deployed ${DOCKERHUB_USER}/${IMAGE_NAME}:latest to cluster."
    }
    failure {
      echo "❌ Pipeline failed. Check build logs for details."
    }
  }
}

