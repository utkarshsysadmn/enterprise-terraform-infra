resource "aws_instance" "ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = false
  iam_instance_profile = var.iam_instance_profile

  # Root Volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "${var.project_name}-${var.environment}-root-volume"
    }
  }

  # Application Volume
  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "${var.project_name}-${var.environment}-application-volume"
    }
  }

  # Database/Data Volume
  ebs_block_device {
    device_name           = "/dev/xvdc"
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = "${var.project_name}-${var.environment}-database-volume"
    }
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_eip" "ec2" {
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-eip"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_eip_association" "ec2" {
  instance_id   = aws_instance.ec2.id
  allocation_id = aws_eip.ec2.id
}


