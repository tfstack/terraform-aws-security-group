terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.29"
    }
  }
}

# # Data source to get the available availability zones
# data "aws_availability_zones" "available" {}

# Generate a random suffix for resource naming
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# VPC for test setup
resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "test-vpc-${random_string.suffix.result}"
  }
}

# # Public Subnet within the VPC
# resource "aws_subnet" "test_subnet" {
#   vpc_id                  = aws_vpc.test_vpc.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = data.aws_availability_zones.available.names[0]
#   tags = {
#     Name = "test-subnet-${random_string.suffix.result}"
#   }
# }

# # Security group for basic testing (optional)
# resource "aws_security_group" "this" {
#   name        = "test-sg"
#   description = "Test security group for unit tests"
#   vpc_id      = aws_vpc.test_vpc.id

#   # Ingress rule for HTTP
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Egress rule to allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "test-sg"
#     Environment = "Test"
#   }
# }

# # Output the Security Group ID for use in tests
# output "security_group_id" {
#   value = aws_security_group.this.id
# }

# # Output the Security Group Name for use in tests
# output "security_group_name" {
#   value = aws_security_group.this.name
# }

# # Output Subnet ID for use in tests
# output "subnet_id" {
#   value = aws_subnet.test_subnet.id
# }



# Output suffix for use in tests
output "suffix" {
  value = random_string.suffix.result
}

# Output VPC ID for use in tests
output "vpc_id" {
  value = aws_vpc.test_vpc.id
}
