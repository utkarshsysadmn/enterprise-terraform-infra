pipeline {

    agent any

    options {
        ansiColor('xterm')
        timestamps()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        TF_DIR = "terraform/live/uat"
    }

    stages {

        stage('Checkout Source') {
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
                dir('terraform') {
                    sh 'terraform fmt -recursive -check'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform init \
                        -input=false
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform plan \
                        -input=false \
                        -var-file=terraform.tfvars \
                        -out=tfplan
                    '''
                }
            }
        }

        stage('Manual Approval') {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    input(
                        message: 'Terraform Plan completed successfully.\n\nDo you want to APPLY the changes?',
                        ok: 'Apply Terraform'
                    )
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                        terraform apply \
                        -input=false \
                        -auto-approve \
                        tfplan
                    '''
                }
            }
        }

    }

    post {

        success {
            echo "========================================="
            echo "Terraform Deployment Successful"
            echo "========================================="
        }

        failure {
            echo "========================================="
            echo "Terraform Pipeline Failed"
            echo "========================================="
        }

        always {
            cleanWs()
        }

    }
}