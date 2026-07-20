output "jenkins_public_ip" {
  value = module.ec2.public_ip
}

output "jenkins_instance_id" {
  value = module.ec2.instance_id
}

output "jenkins_url" {
  value = "http://${module.ec2.public_ip}"
}