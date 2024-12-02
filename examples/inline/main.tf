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

module "security_group_webserver" {
  source = "../.."

  name        = "webserver-${random_string.suffix.result}"
  description = "Webserver security group"
  vpc_id      = aws_vpc.example.id

  inline_ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
      name        = ""
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS from anywhere"
    }
  ]
  inline_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]

  tags = {
    Name = "webserver-${random_string.suffix.result}"
  }
}
