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
  default     = null
}

variable "name" {
  description = "The name of the security group. This is required if `create_sg` is true. If `create_sg` is false, the security group won't be created, and this value is ignored."
  type        = string
  default     = null
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
  description = "A list of ingress rules to define allowed inbound traffic to the security group. Each rule specifies the source IP, ports, and protocols allowed. Defaults to an empty list if not specified."
  type = list(object({
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = optional(string, null)
    cidr_ipv6                    = optional(string, null)
    description                  = optional(string, null)
    prefix_list_id               = optional(string, null)
    referenced_security_group_id = optional(string, null)
    tags                         = optional(map(string), null)
  }))
  default = []
}

variable "advance_egress_rules" {
  description = "A list of egress rules to define allowed outbound traffic from the security group. Each rule specifies the destination IP, ports, and protocols allowed. Defaults to an empty list if not specified."
  type = list(object({
    from_port                    = number
    to_port                      = number
    ip_protocol                  = string
    cidr_ipv4                    = optional(string, null)
    cidr_ipv6                    = optional(string, null)
    description                  = optional(string, null)
    prefix_list_id               = optional(string, null)
    referenced_security_group_id = optional(string, null)
    tags                         = optional(map(string), null)
  }))
  default = []
}

variable "custom_ingress_rules" {
  description = "A list of ingress rules to define allowed inbound traffic to the security group."
  type = list(object({
    rule_name                    = string
    cidr_ipv4                    = optional(string, null)
    cidr_ipv6                    = optional(string, null)
    description                  = optional(string, null)
    prefix_list_id               = optional(string, null)
    referenced_security_group_id = optional(string, null)
    tags                         = optional(map(string), null)
  }))
  default = []

  validation {
    condition     = alltrue([for rule in var.custom_ingress_rules : contains(keys(local.rule_names), rule.rule_name)])
    error_message = "Each rule_name in custom_ingress_rules must exist in the predefined rule_names map."
  }
}

variable "custom_egress_rules" {
  description = "A list of ingress rules to define allowed outbound traffic to the security group."
  type = list(object({
    rule_name                    = string
    cidr_ipv4                    = optional(string, null)
    cidr_ipv6                    = optional(string, null)
    description                  = optional(string, null)
    prefix_list_id               = optional(string, null)
    referenced_security_group_id = optional(string, null)
    tags                         = optional(map(string), null)
  }))
  default = []

  validation {
    condition     = alltrue([for rule in var.custom_egress_rules : contains(keys(local.rule_names), rule.rule_name)])
    error_message = "Each rule_name in custom_egress_rules must exist in the predefined rule_names map."
  }
}

variable "inline_ingress_rules" {
  description = "A list of inline ingress rules to define allowed inbound traffic to the security group. Each rule specifies the source IP, ports, and protocols allowed. Defaults to an empty list if not specified."
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), null)
    ipv6_cidr_blocks = optional(list(string), null)
    prefix_list_ids  = optional(list(string), null)
    security_groups  = optional(list(string), null)
    description      = optional(string, null)
  }))
  default = []
}

variable "inline_egress_rules" {
  description = "A list of inline egress rules to define allowed outbound traffic from the security group. Each rule specifies the destination IP, ports, and protocols. Defaults to an empty list if not specified."
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string), null)
    ipv6_cidr_blocks = optional(list(string), null)
    prefix_list_ids  = optional(list(string), null)
    security_groups  = optional(list(string), null)
    description      = optional(string, null)
  }))
  default = []
}
