locals {
  # add new security group rules here
  port_map = {
    ssh = {
      ports       = [22]
      description = "SSH access"
    }
    kube_api = {
      ports       = [6443]
      description = "Kubernetes API server"
    }
    etcd = {
      ports       = [2379, 2380]
      description = "etcd server"
    }
    kubelet = {
      ports       = [10250]
      description = "Kubelet API"
    }
    scheduler = {
      ports       = [10251]
      description = "kube-scheduler"
    }
    controller = {
      ports       = [10252]
      description = "kube-controller-manager"
    }
    nodeport = {
      ports       = [30000, 32767]
      description = "NodePort Services"
    }
  }



  sg_rules = flatten([
    for group_name, group in local.port_map : [
      for port in group.ports : {
        name        = group_name
        port        = port
        description = group.description
      }
    ]
  ])
}



module "cloudhaven-vpc" {
  source = "../../../../modules/aws/vpc/"

  name            = "cloudhaven-vpc"
  cidr_block      = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    VpcName = "cloudhaven-vpc"
  }
}

resource "aws_security_group_rule" "cloudhaven-ec2-sg_ingress" {
  for_each = { for rule in local.sg_rules : "${rule.name}-${rule.port}" => rule }

  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  description       = each.value.description
  security_group_id = "sg-0982ce650526b7543"
  self              = true
}


resource "aws_security_group_rule" "cloudhaven-ec2-sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "sg-0982ce650526b7543"
  description       = "Allow all outbound TCP traffic"
}


import {
  id = "sg-0982ce650526b7543_egress_tcp_0_65535_0.0.0.0/0"
  to = aws_security_group_rule.cloudhaven-ec2-sg_egress
}

