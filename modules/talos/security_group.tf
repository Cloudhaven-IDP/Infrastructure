#------------------------------------------------------------------------------
# Cluster SG — intra-cluster traffic + Talos API
#------------------------------------------------------------------------------

resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster"
  description = "Intra-cluster traffic and Talos API"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${var.cluster_name}-cluster" })
}

resource "aws_security_group_rule" "cluster_self" {
  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  description       = "All intra-cluster traffic"
}

resource "aws_security_group_rule" "talos_api" {
  security_group_id = aws_security_group.cluster.id
  type              = "ingress"
  from_port         = 50000
  to_port           = 50000
  protocol          = "tcp"
  cidr_blocks       = var.talos_api_allowed_cidrs
  description       = "Talos API"
}

resource "aws_security_group_rule" "cluster_egress" {
  security_group_id = aws_security_group.cluster.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All outbound"
}

#------------------------------------------------------------------------------
# Kubernetes API SG — port 6443 access
#------------------------------------------------------------------------------

resource "aws_security_group" "kubernetes_api" {
  name        = "${var.cluster_name}-k8s-api"
  description = "Kubernetes API access"
  vpc_id      = var.vpc_id
  tags        = merge(local.tags, { Name = "${var.cluster_name}-k8s-api" })
}

resource "aws_security_group_rule" "kubernetes_api" {
  security_group_id = aws_security_group.kubernetes_api.id
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = var.kubernetes_api_allowed_cidrs
  description       = "Kubernetes API"
}

resource "aws_security_group_rule" "kubernetes_api_egress" {
  security_group_id = aws_security_group.kubernetes_api.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "All outbound"
}

resource "aws_security_group_rule" "additional_api" {
  for_each = { for idx, rule in var.additional_api_ingress_rules : idx => rule }

  security_group_id = aws_security_group.kubernetes_api.id
  type              = "ingress"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
}
