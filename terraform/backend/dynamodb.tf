resource "aws_dynamodb_table" "terraform_lock" {

  name         = "${var.project_name}-${var.environment}-terraform-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}