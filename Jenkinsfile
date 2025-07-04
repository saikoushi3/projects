// Jenkinsfile (Declarative Pipeline) for Custom K8s and Docker Hub

pipeline {
    agent any

    environment {
        // Your Docker Hub username
        DOCKERHUB_USERNAME = "koushidev" // CHANGE THIS
        // The name of your image repository on Docker Hub
        IMAGE_REPO_NAME = "nodejs-test-app" // CHANGE THIS
        // Full image name for Docker Hub
        DOCKER_IMAGE = "${DOCKERHUB_USERNAME}/${IMAGE_REPO_NAME}"
        // The ID you give your Docker Hub credentials in Jenkins
        DOCKER_CREDENTIALS_ID = "docker-hub-acces" // This must match the ID in Jenkins
        // The ID you give your kubeconfig file in Jenkins
        KUBECONFIG_CREDENTIALS_ID = "kubernetes-acces" // This must match the ID in Jenkins
    }

    stages {
        stage('Checkout Code') {
            steps {
                 git branch: 'feature', url: 'https://github.com/saikoushi3/projects.git' // CHANGE THIS
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image, tagging with the build number
                    sh "docker build -t ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                script {
                    // Jenkins' withRegistry block handles login and logout securely
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        // Push the image with the build number tag
                        sh "docker push ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"

                        // Also push a 'latest' tag
                        sh "docker tag ${DOCKER_IMAGE}:${env.BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Use the withKubeconfig wrapper to securely provide the kubeconfig file
                // to the steps within this block. Jenkins makes it available at the path
                // specified by the KUBECONFIG environment variable.
                withCredentials([file(credentialsId: KUBECONFIG_CREDENTIALS_ID, variable: 'KUBECONFIG')]) {
                    script {
                        echo 'INFO: Kubeconfig set. Now deploying to the custom cluster.'

                        // Dynamically update the image in the deployment manifest
                        sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE}:${env.BUILD_NUMBER}|' deployment.yml"
                        
                        // Apply the updated configurations
                        sh "kubectl apply -f deployment.yml"
                        sh "kubectl apply -f service.yml"

                        echo 'INFO: Verifying deployment...'
                        sh "kubectl rollout status deployment/nodejs-app-deployment"
                    }
                }
            }
        }
    }
    
    post {
        always {
            script {
                // Clean up the local Docker image from the Jenkins server
                sh "docker rmi ${DOCKER_IMAGE}:${env.BUILD_NUMBER} || true"
            }
        }
    }
}
