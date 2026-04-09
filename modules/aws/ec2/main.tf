locals {
  tags        = merge({ Name = var.name }, var.tags)
  create_role = length(var.policy_arns) > 0 || length(var.inline_policies) > 0

  iam_instance_profile = local.create_role ? aws_iam_instance_profile.this[0].name : var.iam_instance_profile
}

module "role" {
  count  = local.create_role ? 1 : 0
  source = "../iam/role"

  role_name   = "${var.name}-role"
  description = "IAM role for EC2 instance ${var.name}"

  principals = {
    type        = "Service"
    identifiers = ["ec2.amazonaws.com"]
  }

  policy_arns     = var.policy_arns
  inline_policies = var.inline_policies
  tags            = local.tags
}

resource "aws_iam_instance_profile" "this" {
  count = local.create_role ? 1 : 0

  name = "${var.name}-profile"
  role = module.role[0].role_name
  tags = local.tags
}

resource "aws_security_group" "this" {
  name        = var.name
  description = "${var.name} security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", [])
    }
  }

  tags = local.tags
}

resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = concat([aws_security_group.this.id], var.extra_security_group_ids)
  iam_instance_profile        = local.iam_instance_profile
  user_data                   = var.user_data
  associate_public_ip_address = var.associate_public_ip
  source_dest_check           = var.source_dest_check
  key_name                    = var.key_name

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = var.root_volume_encrypted
    delete_on_termination = true
  }

  lifecycle {
    ignore_changes = [ami]
  }

  tags = local.tags
}
