resource "aws_security_group" "this" {
  name                   = var.name
  description            = var.description
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = var.tags

  dynamic "ingress" {
    for_each = var.inline_ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      description      = lookup(ingress.value, "description", null)
    }
  }

  dynamic "egress" {
    for_each = var.inline_egress_rules
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      description      = lookup(egress.value, "description", null)
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "advance" {
  count = length(var.advance_ingress_rules) > 0 ? length(var.advance_ingress_rules) : 0

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = lookup(var.advance_ingress_rules[count.index], "cidr_ipv4", null)
  cidr_ipv6                    = lookup(var.advance_ingress_rules[count.index], "cidr_ipv6", null)
  description                  = lookup(var.advance_ingress_rules[count.index], "description", null)
  from_port                    = var.advance_ingress_rules[count.index].from_port
  ip_protocol                  = var.advance_ingress_rules[count.index].ip_protocol
  prefix_list_id               = lookup(var.advance_ingress_rules[count.index], "prefix_list_id", null)
  referenced_security_group_id = lookup(var.advance_ingress_rules[count.index], "referenced_security_group_id", null)
  tags                         = lookup(var.advance_ingress_rules[count.index], "tags", null)
  to_port                      = var.advance_ingress_rules[count.index].to_port
}

resource "aws_vpc_security_group_egress_rule" "advance" {
  count = length(var.advance_egress_rules) > 0 ? length(var.advance_egress_rules) : 0

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = lookup(var.advance_egress_rules[count.index], "cidr_ipv4", null)
  cidr_ipv6                    = lookup(var.advance_egress_rules[count.index], "cidr_ipv6", null)
  description                  = lookup(var.advance_egress_rules[count.index], "description", null)
  from_port                    = var.advance_egress_rules[count.index].from_port
  ip_protocol                  = var.advance_egress_rules[count.index].ip_protocol
  prefix_list_id               = lookup(var.advance_egress_rules[count.index], "prefix_list_id", null)
  referenced_security_group_id = lookup(var.advance_egress_rules[count.index], "referenced_security_group_id", null)
  tags                         = lookup(var.advance_egress_rules[count.index], "tags", null)
  to_port                      = var.advance_egress_rules[count.index].to_port
}

resource "aws_vpc_security_group_ingress_rule" "custom" {
  count = length(var.custom_ingress_rules) > 0 ? length(var.custom_ingress_rules) : 0

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = var.custom_ingress_rules[count.index].cidr_ipv4
  cidr_ipv6                    = var.custom_ingress_rules[count.index].cidr_ipv6
  description                  = local.rule_names[var.custom_ingress_rules[count.index].rule_name][3]
  from_port                    = local.rule_names[var.custom_ingress_rules[count.index].rule_name][0]
  ip_protocol                  = local.rule_names[var.custom_ingress_rules[count.index].rule_name][2]
  prefix_list_id               = var.custom_ingress_rules[count.index].prefix_list_id
  referenced_security_group_id = var.custom_ingress_rules[count.index].referenced_security_group_id
  tags                         = var.custom_ingress_rules[count.index].tags
  to_port                      = local.rule_names[var.custom_ingress_rules[count.index].rule_name][1]
}

resource "aws_vpc_security_group_egress_rule" "custom" {
  count = length(var.custom_egress_rules) > 0 ? length(var.custom_egress_rules) : 0

  security_group_id            = aws_security_group.this.id
  cidr_ipv4                    = var.custom_egress_rules[count.index].cidr_ipv4
  cidr_ipv6                    = var.custom_egress_rules[count.index].cidr_ipv6
  description                  = local.rule_names[var.custom_egress_rules[count.index].rule_name][3]
  from_port                    = local.rule_names[var.custom_egress_rules[count.index].rule_name][0]
  ip_protocol                  = local.rule_names[var.custom_egress_rules[count.index].rule_name][2]
  prefix_list_id               = var.custom_egress_rules[count.index].prefix_list_id
  referenced_security_group_id = var.custom_egress_rules[count.index].referenced_security_group_id
  tags                         = var.custom_egress_rules[count.index].tags
  to_port                      = local.rule_names[var.custom_egress_rules[count.index].rule_name][1]
}
