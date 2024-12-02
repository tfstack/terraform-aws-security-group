terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.29"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

# use of random suffix to avoid duplicate resource
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
  lower   = true
  numeric = false
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "test-vpc-${random_string.suffix.result}"
  }
}

data "http" "my_public_ip" {
  url = "http://ifconfig.me/ip"
}

module "security_group_jumphost" {
  source = "../.."

  name        = "jumphost-${random_string.suffix.result}"
  description = "Security group for Jumphost, enabling restricted SSH access"
  vpc_id      = aws_vpc.example.id

  custom_ingress_rules = [
    {
      rule_name   = "ssh-22-tcp"
      cidr_ipv4   = "${data.http.my_public_ip.response_body}/32"
      description = "Allow SSH from specific public IP for administrative access"
      tags = {
        Purpose  = "Admin Access"
        Protocol = "TCP"
        Port     = "22"
        Access   = "Inbound"
      }
    }
  ]

  custom_egress_rules = [
    {
      rule_name   = "ssh-22-tcp"
      cidr_ipv4   = "10.0.0.0/16"
      description = "Allow outbound traffic to internal network range"
      tags = {
        Purpose  = "Internal Communication"
        Protocol = "TCP"
        Port     = "22"
        Access   = "Outbound"
      }
    }
  ]

  tags = {
    Name        = "jumphost-${random_string.suffix.result}"
    Environment = "Development"
    Project     = "Network Security"
    ManagedBy   = "Terraform"
  }
}
