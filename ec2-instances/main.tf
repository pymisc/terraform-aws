terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Get the latest Amazon Linux 2023 x86_64 AMI
data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Use the default VPC
data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ec2_ssh" {
  name        = "terraform-testing-ssh"
  description = "Allow SSH access to Terraform testing EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-testing-ssh"
  }
}

resource "aws_instance" "terraform_testing" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.ec2_ssh.id
  ]

  tags = {
    Name = "terraform-testing-01"
    app  = "testing"
  }
}