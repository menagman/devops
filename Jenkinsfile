pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-west-2"
    }

    stages {

        stage('Checkout Terraform Code') {
            steps {
                git branch: 'main', url: 'https://github.com/menagman/devops.git'
            }
        }


        stage('Setup AWS Credentials') {
            steps {
                withAWS(credentials: 'aws-creds', region: 'us-west-2') {
                    bat 'aws sts get-caller-identity'                            
                }
            }
        }


        stage('Initialize Terraform') {
            steps {
                bat 'terraform init'
            }
        }

        stage('Plan Infrastructure') {
            steps {
                withAWS(region: 'us-west-2', credentials: 'aws-creds') {
                    withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}",
                             "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}"]) {
                  bat 'terraform plan -out=tfplan'
                }
            }
          }
        }

        stage('Apply Infrastructure') {
            steps {
                withAWS(region: 'us-west-2', credentials: 'aws-creds') {
                    withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}",
                             "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}"]) {
                  input message: 'Proceed with Terraform apply?'
                   bat 'terraform apply -auto-approve tfplan'
                }
            }  
          }
        }

        stage('Output Public IP') {
            steps {
                bat 'terraform output'
            }
        }
    }


    post {
        success {
            echo '✅ AWS infrastructure provisioned successfully.'
        }
        failure {
            echo '❌ Failed to provision AWS infrastructure.'
        }
    }
}