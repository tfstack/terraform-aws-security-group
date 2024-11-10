locals {
  rule_names = {
    "activemq-5671-tcp"      = [5671, 5671, "tcp", "ActiveMQ AMQP"]
    "http-80-tcp"            = [80, 80, "tcp", "HTTP Traffic"]
    "http-8080-tcp"          = [8080, 8080, "tcp", "HTTP Alternate Traffic"]
    "https-443-tcp"          = [443, 443, "tcp", "HTTPS Traffic"]
    "https-8443-tcp"         = [8443, 8443, "tcp", "HTTPS Alternate Traffic"]
    "ssh-22-tcp"             = [22, 22, "tcp", "SSH Access"]
    "postgresql-5432-tcp"    = [5432, 5432, "tcp", "PostgreSQL Database"]
    "mysql-3306-tcp"         = [3306, 3306, "tcp", "MySQL Database"]
    "redis-6379-tcp"         = [6379, 6379, "tcp", "Redis Cache"]
    "mongodb-27017-tcp"      = [27017, 27017, "tcp", "MongoDB Database"]
    "smtp-25-tcp"            = [25, 25, "tcp", "SMTP Email"]
    "smtps-465-tcp"          = [465, 465, "tcp", "Secure SMTP Email"]
    "ftp-21-tcp"             = [21, 21, "tcp", "FTP File Transfer"]
    "ftps-990-tcp"           = [990, 990, "tcp", "FTPS File Transfer"]
    "sftp-22-tcp"            = [22, 22, "tcp", "SFTP over SSH"]
    "dns-53-udp"             = [53, 53, "udp", "DNS Service"]
    "ldap-389-tcp"           = [389, 389, "tcp", "LDAP Directory"]
    "ldaps-636-tcp"          = [636, 636, "tcp", "Secure LDAP"]
    "nfs-2049-tcp"           = [2049, 2049, "tcp", "NFS File Share"]
    "oracle-1521-tcp"        = [1521, 1521, "tcp", "Oracle Database"]
    "ms-sql-1433-tcp"        = [1433, 1433, "tcp", "Microsoft SQL Server"]
    "rds-3306-tcp"           = [3306, 3306, "tcp", "RDS MySQL Database"]
    "rds-5432-tcp"           = [5432, 5432, "tcp", "RDS PostgreSQL Database"]
    "rds-1433-tcp"           = [1433, 1433, "tcp", "RDS SQL Server Database"]
    "elasticsearch-9200-tcp" = [9200, 9200, "tcp", "Elasticsearch HTTP API"]
    "kafka-9092-tcp"         = [9092, 9092, "tcp", "Apache Kafka"]
    "cassandra-9042-tcp"     = [9042, 9042, "tcp", "Cassandra Database"]
    "zookeeper-2181-tcp"     = [2181, 2181, "tcp", "Zookeeper Coordination Service"]
    "jenkins-8080-tcp"       = [8080, 8080, "tcp", "Jenkins CI/CD Server"]
    "git-9418-tcp"           = [9418, 9418, "tcp", "Git Protocol"]
    "consul-8500-tcp"        = [8500, 8500, "tcp", "Consul Service Discovery"]
    "vault-8200-tcp"         = [8200, 8200, "tcp", "HashiCorp Vault API"]
    "snmp-161-udp"           = [161, 161, "udp", "Simple Network Management Protocol (SNMP)"]
    "rdesktop-3389-tcp"      = [3389, 3389, "tcp", "Remote Desktop Protocol (RDP)"]
    "memcached-11211-tcp"    = [11211, 11211, "tcp", "Memcached Cache"]
    "couchbase-8091-tcp"     = [8091, 8091, "tcp", "Couchbase Database"]
    "neo4j-7474-tcp"         = [7474, 7474, "tcp", "Neo4j Database"]
    "rabbitmq-5672-tcp"      = [5672, 5672, "tcp", "RabbitMQ AMQP"]
    "openvpn-1194-udp"       = [1194, 1194, "udp", "OpenVPN"]
    "ipsec-500-udp"          = [500, 500, "udp", "IPSec VPN"]
    "pptp-1723-tcp"          = [1723, 1723, "tcp", "PPTP VPN"]
    "smb-445-tcp"            = [445, 445, "tcp", "SMB File Sharing"]
    "vnc-5900-tcp"           = [5900, 5900, "tcp", "VNC Remote Access"]
    "grafana-3000-tcp"       = [3000, 3000, "tcp", "Grafana Monitoring"]
    "prometheus-9090-tcp"    = [9090, 9090, "tcp", "Prometheus Monitoring"]

    # Additional rules as needed
  }
}

variable "vpc_id" {
  description = "The ID of the VPC (Virtual Private Cloud) where the security group will be created. This is a required field to associate the security group with a specific VPC."
  type        = string
}

variable "name" {
  description = "The name of the security group. This is required if `create_sg` is true. If `create_sg` is false, the security group won't be created, and this value is ignored."
  type        = string
}

variable "description" {
  description = "A description of the security group. If not specified, the default value 'Security Group managed by Terraform' will be used."
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "revoke_rules_on_delete" {
  description = "Whether to revoke all ingress and egress rules before deleting the security group. This is recommended for Elastic MapReduce (EMR) security groups to ensure proper cleanup of associated rules."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the security group. Tags are useful for identifying and managing resources in AWS. If no tags are provided, an empty map will be used."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "The time to wait for the security group to be successfully created. The default is '10m', but this can be adjusted based on the environment or delays in resource creation."
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "The time to wait for the security group to be successfully deleted. The default is '15m', which can be adjusted depending on the complexity or size of the environment."
  type        = string
  default     = "15m"
}

variable "advance_ingress_rules" {
  description = <<EOT
    advance_ingress_rules = {
      A list of ingress rules that define allowed inbound traffic to the security group. Each rule can specify:
      from_port : "Starting port for traffic (number, required)"
      to_port : "Protocol type (string, required, e.g., "tcp", "udp", "-1" for all)"
      ip_protocol : "Organization ID where the service account belongs"
      cidr_ipv4 : "Source IPv4 CIDR block (optional, e.g., "0.0.0.0/0")"
      cidr_ipv6 : "Source IPv6 CIDR block (optional, e.g., "::/0")"
      description : "A description for the rule (optional, string)"
      prefix_list_id : "AWS prefix list ID for managed lists (optional, string)"
      referenced_security_group_id : "referenced_security_group_id: ID of another security group to allow traffic from (optional, string)"
      tags : "Key-value map of tags to apply to the rule (optional, map of strings)"
    }
  EOT

  type = list(object({
    from_port                    = number                      # Starting port for the rule
    to_port                      = number                      # Ending port for the rule
    ip_protocol                  = string                      # Protocol (e.g., "tcp", "udp")
    cidr_ipv4                    = optional(string, null)      # Source IPv4 CIDR
    cidr_ipv6                    = optional(string, null)      # Source IPv6 CIDR
    description                  = optional(string, null)      # Rule description
    prefix_list_id               = optional(string, null)      # AWS prefix list ID
    referenced_security_group_id = optional(string, null)      # Referenced security group ID
    tags                         = optional(map(string), null) # Tags for the rule
  }))

  default = []
}

variable "advance_egress_rules" {
  description = <<EOT
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
EOT

  type = list(object({
    from_port                    = number                      # Starting port for the rule
    to_port                      = number                      # Ending port for the rule
    ip_protocol                  = string                      # Protocol (e.g., "tcp", "udp")
    cidr_ipv4                    = optional(string, null)      # Destination IPv4 CIDR
    cidr_ipv6                    = optional(string, null)      # Destination IPv6 CIDR
    description                  = optional(string, null)      # Rule description
    prefix_list_id               = optional(string, null)      # AWS prefix list ID
    referenced_security_group_id = optional(string, null)      # Referenced security group ID
    tags                         = optional(map(string), null) # Tags for the rule
  }))

  default = []
}

variable "custom_ingress_rules" {
  description = <<EOT
A list of custom ingress rules defining allowed inbound traffic to the security group. Each rule includes:

- rule_name: A predefined name representing the rule (string, required).
- cidr_ipv4: IPv4 CIDR block for source traffic (optional, string).
- cidr_ipv6: IPv6 CIDR block for source traffic (optional, string).
- description: A description of the rule (optional, string).
- prefix_list_id: AWS prefix list ID for managed IP ranges (optional, string).
- referenced_security_group_id: ID of a security group to allow traffic from (optional, string).
- tags: Key-value pairs for tagging (optional, map of strings).

All `rule_name` values in custom_ingress_rules must match a predefined rule in the `rule_names` map. Defaults to an empty list if no ingress rules are provided.
EOT

  type = list(object({
    rule_name                    = string                      # Name of the rule, must match predefined rule names
    cidr_ipv4                    = optional(string, null)      # Source IPv4 CIDR
    cidr_ipv6                    = optional(string, null)      # Source IPv6 CIDR
    description                  = optional(string, null)      # Description of the rule
    prefix_list_id               = optional(string, null)      # AWS prefix list ID
    referenced_security_group_id = optional(string, null)      # Referenced security group ID
    tags                         = optional(map(string), null) # Tags for the rule
  }))

  default = []

  validation {
    condition     = alltrue([for rule in var.custom_ingress_rules : contains(keys(local.rule_names), rule.rule_name)])
    error_message = "Each rule_name in custom_ingress_rules must exist in the predefined rule_names map."
  }
}

variable "custom_egress_rules" {
  description = <<EOT
A list of custom egress rules defining allowed outbound traffic from the security group. Each rule includes:

- rule_name: A predefined name representing the rule (string, required).
- cidr_ipv4: IPv4 CIDR block for destination traffic (optional, string).
- cidr_ipv6: IPv6 CIDR block for destination traffic (optional, string).
- description: A description of the rule (optional, string).
- prefix_list_id: AWS prefix list ID for managed IP ranges (optional, string).
- referenced_security_group_id: ID of a security group to allow traffic to (optional, string).
- tags: Key-value pairs for tagging (optional, map of strings).

All `rule_name` values in custom_egress_rules must match a predefined rule in the `rule_names` map. Defaults to an empty list if no egress rules are provided.
EOT

  type = list(object({
    rule_name                    = string                      # Name of the rule, must match predefined rule names
    cidr_ipv4                    = optional(string, null)      # Destination IPv4 CIDR
    cidr_ipv6                    = optional(string, null)      # Destination IPv6 CIDR
    description                  = optional(string, null)      # Description of the rule
    prefix_list_id               = optional(string, null)      # AWS prefix list ID
    referenced_security_group_id = optional(string, null)      # Referenced security group ID
    tags                         = optional(map(string), null) # Tags for the rule
  }))

  default = []

  validation {
    condition     = alltrue([for rule in var.custom_egress_rules : contains(keys(local.rule_names), rule.rule_name)])
    error_message = "Each rule_name in custom_egress_rules must exist in the predefined rule_names map."
  }
}

variable "inline_ingress_rules" {
  description = <<EOT
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
EOT

  type = list(object({
    from_port        = number                       # Starting port for allowed traffic
    to_port          = number                       # Ending port for allowed traffic
    protocol         = string                       # Protocol (e.g., "tcp" or "udp")
    cidr_blocks      = optional(list(string), null) # IPv4 CIDR blocks
    ipv6_cidr_blocks = optional(list(string), null) # IPv6 CIDR blocks
    prefix_list_ids  = optional(list(string), null) # AWS prefix list IDs for IP ranges
    security_groups  = optional(list(string), null) # Security group IDs for source security groups
    description      = optional(string, null)       # Description of the rule
  }))

  default = []
}

variable "inline_egress_rules" {
  description = <<EOT
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
EOT

  type = list(object({
    from_port        = number                       # Starting port for allowed traffic
    to_port          = number                       # Ending port for allowed traffic
    protocol         = string                       # Protocol (e.g., "tcp" or "udp")
    cidr_blocks      = optional(list(string), null) # IPv4 CIDR blocks
    ipv6_cidr_blocks = optional(list(string), null) # IPv6 CIDR blocks
    prefix_list_ids  = optional(list(string), null) # AWS prefix list IDs for IP ranges
    security_groups  = optional(list(string), null) # Security group IDs for destination security groups
    description      = optional(string, null)       # Description of the rule
  }))

  default = []
}
