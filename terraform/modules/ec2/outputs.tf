output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.ec2.id
}

output "private_ip" {
  description = "Private IP Address"
  value       = aws_instance.ec2.private_ip
}

output "elastic_ip" {
  description = "Elastic IP Address"
  value       = aws_eip.ec2.public_ip
}

output "elastic_ip_allocation_id" {
  description = "Elastic IP Allocation ID"
  value       = aws_eip.ec2.id
}