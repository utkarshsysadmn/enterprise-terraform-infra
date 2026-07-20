pipeline {
    agent any

    options {
        ansiColor('xterm')
        timestamps()
    }

    environment {
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh '''
                cd terraform
                terraform fmt -recursive -check
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                cd terraform/live/uat
                terraform init
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                cd terraform/live/uat
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd terraform/live/uat
                terraform plan
                '''
            }
        }
    }

    post {
        success {
            echo 'Terraform Validation Successful'
        }

        failure {
            echo 'Terraform Validation Failed'
        }

        always {
            cleanWs()
        }
    }
}
