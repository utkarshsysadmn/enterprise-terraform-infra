terraform {
  backend "s3" {
    bucket = "YOUR-TFSTATE-BUCKET"

    key = "jenkins/terraform.tfstate"

    region = "us-east-1"

    use_lockfile = true
  }
}