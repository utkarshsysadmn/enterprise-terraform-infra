terraform {
  backend "s3" {
    bucket         = "enterprise-uat-terraform-state-472224962365"
    key            = "jenkins/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "enterprise-uat-terraform-lock"
    encrypt        = true
  }
}