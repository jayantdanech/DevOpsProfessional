pipeline {
    agent any

    environment {
        KUBECONFIG = credentials('kubeconfig-cred')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    echo ">>> Deploying application using DockerHub image"

                    kubectl apply -f app_deployment.yml

                    echo ">>> Restarting deployment to force latest image pull"
                    kubectl rollout restart deployment/devops-capstone1

                    echo ">>> Waiting for rollout to complete"
                    kubectl rollout status deployment/devops-capstone1 --timeout=120s

                    echo ">>> Application deployed successfully!"
                '''
            }
        }
    }

    post {
        success {
            echo "✔ Deployment Pipeline Completed Successfully"
        }
        failure {
            echo "❌ Deployment Pipeline Failed"
        }
    }
}

