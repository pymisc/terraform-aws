output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.terraform_testing.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.terraform_testing.public_ip
}

output "ami_id" {
  description = "Amazon Linux 2023 AMI used"
  value       = data.aws_ssm_parameter.amazon_linux_2023.value
}