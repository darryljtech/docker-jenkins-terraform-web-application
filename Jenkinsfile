pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Initialize Terraform') {
            steps {
                script {
                    // Change to the Terraform directory in the Git repository
                    dir('./terraform') {
                        // Run Terraform init
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Destroy Infrastructure') {
            steps {
                script {
                    // Change to the Terraform directory in the Git repository
                    dir('./terraform') {
                        // Destroy the infrastructure
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
