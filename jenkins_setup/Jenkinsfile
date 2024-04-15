pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/darryljtech/docker-jenkins-terraform-web-application.git'
            }
        }
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

        stage('Plan Terraform') {
            steps {
                script {
                    // Change to the Terraform directory in the Git repository
                    dir('./terraform') {
                        // Run Terraform plan and save the output to a file
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {
                    // Change to the Terraform directory in the Git repository
                    dir('./terraform') {
                        // Apply the Terraform plan
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }

    post {
        always {
            // Clean up Terraform plan file
            script {
                deleteFile('./terraform/tfplan')
            }
        }
    }
}

// Function to delete a file if it exists
def deleteFile(filename) {
    sh "rm -f ${filename}"
}