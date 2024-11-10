# terraform-aws-security-group

Terraform module to manage AWS security groups and rules.

This module uses `aws_security_group` and take note about the informational notes and warning detailed on <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group.html>

## Object type variables

### advance_ingress_rules

A list of ingress rules that define allowed inbound traffic to the security group. Each rule can specify:

- from_port: Starting port for traffic (number, required)
- to_port: Ending port for traffic (number, required)
- ip_protocol: Protocol type (string, required, e.g., "tcp", "udp", "-1" for all)
- cidr_ipv4: Source IPv4 CIDR block (optional, e.g., "0.0.0.0/0")
- cidr_ipv6: Source IPv6 CIDR block (optional, e.g., "::/0")
- description: A description for the rule (optional, string)
- prefix_list_id: AWS prefix list ID for managed lists (optional, string)
- referenced_security_group_id: ID of another security group to allow traffic from (optional, string)
- tags: Key-value map of tags to apply to the rule (optional, map of strings)

Defaults to an empty list if no ingress rules are provided.
EOT

### advance_egress_rules

A list of egress rules that define allowed outbound traffic from the security group. Each rule can specify:

- from_port: Starting port for traffic (number, required)
- to_port: Ending port for traffic (number, required)
- ip_protocol: Protocol type (string, required, e.g., "tcp", "udp", "-1" for all)
- cidr_ipv4: Destination IPv4 CIDR block (optional, e.g., "0.0.0.0/0")
- cidr_ipv6: Destination IPv6 CIDR block (optional, e.g., "::/0")
- description: A description for the rule (optional, string)
- prefix_list_id: AWS prefix list ID for managed lists (optional, string)
- referenced_security_group_id: ID of another security group to allow traffic to (optional, string)
- tags: Key-value map of tags to apply to the rule (optional, map of strings)

Defaults to an empty list if no egress rules are provided.

### custom_ingress_rules

A list of custom ingress rules defining allowed inbound traffic to the security group. Each rule includes:

- rule_name: A predefined name representing the rule (string, required).
- cidr_ipv4: IPv4 CIDR block for source traffic (optional, string).
- cidr_ipv6: IPv6 CIDR block for source traffic (optional, string).
- description: A description of the rule (optional, string).
- prefix_list_id: AWS prefix list ID for managed IP ranges (optional, string).
- referenced_security_group_id: ID of a security group to allow traffic from (optional, string).
- tags: Key-value pairs for tagging (optional, map of strings).

All `rule_name` values in custom_ingress_rules must match a predefined rule in the `rule_names` map. Defaults to an empty list if no ingress rules are provided.

### custom_egress_rules

A list of custom egress rules defining allowed outbound traffic from the security group. Each rule includes:

- rule_name: A predefined name representing the rule (string, required).
- cidr_ipv4: IPv4 CIDR block for destination traffic (optional, string).
- cidr_ipv6: IPv6 CIDR block for destination traffic (optional, string).
- description: A description of the rule (optional, string).
- prefix_list_id: AWS prefix list ID for managed IP ranges (optional, string).
- referenced_security_group_id: ID of a security group to allow traffic to (optional, string).
- tags: Key-value pairs for tagging (optional, map of strings).

All `rule_name` values in custom_egress_rules must match a predefined rule in the `rule_names` map. Defaults to an empty list if no egress rules are provided.

### inline_ingress_rules

A list of inline ingress rules that define allowed inbound traffic to the security group. Each rule includes:

- from_port: Starting port of the allowed traffic range (number, required).
- to_port: Ending port of the allowed traffic range (number, required).
- protocol: Protocol to allow (e.g., "tcp", "udp") (string, required).
- cidr_blocks: IPv4 CIDR blocks allowed for the rule (optional, list of strings).
- ipv6_cidr_blocks: IPv6 CIDR blocks allowed for the rule (optional, list of strings).
- prefix_list_ids: List of AWS-managed prefix list IDs for allowed IP ranges (optional, list of strings).
- security_groups: List of security group IDs to allow traffic from (optional, list of strings).
- description: Description of the rule (optional, string).

Defaults to an empty list if no inline ingress rules are provided.

### inline_egress_rules

A list of inline egress rules defining allowed outbound traffic from the security group. Each rule includes:

- from_port: The starting port of the allowed traffic range (number, required).
- to_port: The ending port of the allowed traffic range (number, required).
- protocol: Protocol to allow (e.g., "tcp", "udp") (string, required).
- cidr_blocks: IPv4 CIDR blocks that traffic can be sent to (optional, list of strings).
- ipv6_cidr_blocks: IPv6 CIDR blocks that traffic can be sent to (optional, list of strings).
- prefix_list_ids: AWS-managed prefix list IDs for allowed IP ranges (optional, list of strings).
- security_groups: List of security group IDs for destination security groups (optional, list of strings).
- description: Description of the rule (optional, string).

Defaults to an empty list if no inline egress rules are provided.
