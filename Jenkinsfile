pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-west2"
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
                    sh 'aws sts get-caller-identity'                            
                }
            }
        }


        stage('Initialize Terraform') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Plan Infrastructure') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Apply Infrastructure') {
            steps {
                input message: 'Proceed with Terraform apply?'
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Output Public IP') {
            steps {
                sh 'terraform output'
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