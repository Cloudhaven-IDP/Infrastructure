locals {
  interface_endpoints = [
    "ssm",
    "ec2",
    "ec2messages",
    "ssmmessages",
  ]

  gateway_endpoints = [
    "s3",
    "dynamodb"
  ]

  all_endpoints = concat(local.interface_endpoints, local.gateway_endpoints)
}

resource "aws_vpc_endpoint" "this" {
  for_each = toset(local.all_endpoints)

  vpc_id            = module.cloudhaven-vpc.vpc_id
  service_name      = "com.amazonaws.${local.config.Region}.${each.key}"
  vpc_endpoint_type = contains(local.gateway_endpoints, each.key) ? "Gateway" : "Interface"

  subnet_ids         = contains(local.gateway_endpoints, each.key) ? null : module.cloudhaven-vpc.private_subnets
  security_group_ids = contains(local.gateway_endpoints, each.key) ? null : [aws_security_group.vpc_endpoints.id]
  private_dns_enabled = contains(local.gateway_endpoints, each.key) ? null : true

  tags = {
    Name = "${each.key}-endpoint"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc-endpoints"
  vpc_id      = module.cloudhaven-vpc.vpc_id
  description = "Allow VPC Endpoint traffic"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] # adjust to match your VPC CIDR or tighter
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
