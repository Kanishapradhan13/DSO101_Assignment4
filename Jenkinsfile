pipeline {
    agent any
    
    environment {
        // Reference stored credentials (SECURITY BEST PRACTICE #2)
        DOCKER_CREDS = credentials('docker-hub-creds')
        IMAGE_NAME = 'my-secure-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Build') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                script {
                    echo 'Running security scan...'
                    // Add security scanning tools here (Trivy, Snyk, etc.)
                    sh "docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image ${IMAGE_NAME}:${IMAGE_TAG} || true"
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    sh "docker run --rm ${IMAGE_NAME}:${IMAGE_TAG} npm test || true"
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying to Docker Hub...'
                    // Login using stored credentials (SECURITY BEST PRACTICE #2)
                    sh 'echo $DOCKER_CREDS_PSW | docker login -u $DOCKER_CREDS_USR --password-stdin'
                    
                    // Push image
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} $DOCKER_CREDS_USR/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} $DOCKER_CREDS_USR/${IMAGE_NAME}:latest"
                    sh "docker push $DOCKER_CREDS_USR/${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker push $DOCKER_CREDS_USR/${IMAGE_NAME}:latest"
                }
            }
        }
    }
    
    post {
        always {
            script {
                echo 'Cleaning up...'
                sh "docker logout"
                sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                sh "docker rmi ${IMAGE_NAME}:latest || true"
            }
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}