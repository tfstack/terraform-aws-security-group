output "security_group_arn" {
  description = "The ARN (Amazon Resource Name) of the security group, providing a unique identifier for the resource."
  value       = try(aws_security_group.this.arn, "")
}

output "security_group_id" {
  description = "The ID of the security group, which uniquely identifies it within the VPC."
  value       = try(aws_security_group.this.id, "")
}

output "security_group_vpc_id" {
  description = "The ID of the VPC (Virtual Private Cloud) where the security group is associated."
  value       = try(aws_security_group.this.vpc_id, "")
}

output "security_group_owner_id" {
  description = "The AWS account ID of the owner of the security group."
  value       = try(aws_security_group.this.owner_id, "")
}

output "security_group_name" {
  description = "The name assigned to the security group. This name is used for identification."
  value       = try(aws_security_group.this.name, "")
}

output "security_group_description" {
  description = "The description of the security group, providing information about its purpose or use."
  value       = try(aws_security_group.this.description, "")
}
