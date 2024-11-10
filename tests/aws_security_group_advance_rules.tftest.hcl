# Run setup to create a VPC
run "setup_vpc" {
  module {
    source = "./tests/setup"
  }
}

# Main test block to create and test the security group in the root module
run "create_security_group_advance" {
  variables {
    vpc_id      = run.setup_vpc.vpc_id
    name        = "test-sg-advance-${run.setup_vpc.suffix}"
    description = "Test security group for unit tests"
    advance_ingress_rules = [
      {
        from_port   = 80
        to_port     = 80
        ip_protocol = "tcp"
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow HTTP from anywhere"
        tags = {
          Type = "Ingress"
        }
      }
    ]
    advance_egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        ip_protocol = "-1"
        cidr_ipv4   = "0.0.0.0/0"
        description = "Allow all outbound traffic"
        tags = {
          Type = "Egress"
        }
      }
    ]
    tags = {
      Environment = "Test"
    }
  }

  # Assert that the VPC ID for the security group matches the VPC created in setup
  assert {
    condition     = aws_security_group.this.vpc_id == run.setup_vpc.vpc_id
    error_message = "Security group VPC ID does not match the setup VPC ID"
  }

  # Assert that the security group description matches the expected format
  assert {
    condition     = aws_security_group.this.description == "Test security group for unit tests"
    error_message = "Security group description does not match the expected description 'Test security group for unit tests'"
  }

  # Assert that the security group name matches the expected format
  assert {
    condition     = aws_security_group.this.name == "test-sg-advance-${run.setup_vpc.suffix}"
    error_message = "Security group name does not match expected name 'test-sg-advance-${run.setup_vpc.suffix}'"
  }

  # Assert that the security group egress rule contains the expected 'Type' tag set to 'Egress'
  assert {
    condition = anytrue([
      for rule in aws_vpc_security_group_egress_rule.advance :
      lookup(rule.tags, "Type", "") == "Egress"
    ])
    error_message = "Security group does not have the expected 'Type' tag set to 'Egress'"
  }

  # Assert that the security group has at least one inbound rule
  assert {
    condition     = length(aws_vpc_security_group_ingress_rule.advance) > 0
    error_message = "Security group has no inbound rules configured"
  }

  # Assert that the security group allows HTTP ingress traffic on port 80.
  assert {
    condition = anytrue([
      for rule in aws_vpc_security_group_ingress_rule.advance :
      rule.from_port == 80 && rule.to_port == 80 && rule.ip_protocol == "tcp"
    ])
    error_message = "Security group does not have the expected HTTP ingress rule on port 80"
  }

  # Assert that the security group has at least one outbound rule
  assert {
    condition     = length(aws_vpc_security_group_egress_rule.advance) > 0
    error_message = "Security group has no outbound rules configured"
  }

  # Assert that the security group allows egress traffic on port 0.
  assert {
    condition = anytrue([
      for rule in aws_vpc_security_group_egress_rule.advance :
      rule.from_port == 0 && rule.to_port == 0 && rule.ip_protocol == "-1"
    ])
    error_message = "Security group does not have the expected egress rule on port 0"
  }
}
