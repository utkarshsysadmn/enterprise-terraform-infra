resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name        = "${var.project_name}-${var.environment}-keypair"
    Environment = var.environment
    Project     = var.project_name
  }
}