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

module "security_group_rdspsqlserver" {
  source = "../.."

  name        = "rdspsqlserver-${random_string.suffix.result}"
  description = "Security group for an RDS PostgreSQL server, allowing inbound PostgreSQL traffic on port 5432 and all outbound traffic."
  vpc_id      = aws_vpc.example.id

  advance_ingress_rules = [
    {
      from_port   = 5432
      to_port     = 5432
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.0.0/16"
      description = "Allow inbound PostgreSQL traffic (TCP) on port 5432 from the 10.0.0.0/16 subnet"
      tags = {
        Role        = "Database"
        Environment = "Production"
        Service     = "RDS"
      }
    }
  ]

  advance_egress_rules = [
    {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow all outbound traffic"
      tags = {
        Role        = "Database"
        Environment = "Production"
        Service     = "RDS"
      }
    }
  ]

  tags = {
    Name = "rdspsqlserver-${random_string.suffix.result}"
  }
}
