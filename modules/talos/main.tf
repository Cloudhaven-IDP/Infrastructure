#------------------------------------------------------------------------------
# Control plane — individual EC2 instances via ec2 module
# (Talos config apply needs stable IPs for bootstrap)
#------------------------------------------------------------------------------

module "control_plane" {
  source = "../aws/ec2"
  count  = var.control_plane_count

  name          = "${var.cluster_name}-cp-${count.index}"
  environment   = var.environment
  ami_id        = local.ami_id
  instance_type = var.control_plane_instance_type
  subnet_id     = element(var.subnet_ids, count.index)
  vpc_id        = var.vpc_id

  associate_public_ip = var.associate_public_ip
  root_volume_size    = var.control_plane_volume_size

  ingress_rules            = []
  extra_security_group_ids = concat([aws_security_group.cluster.id, aws_security_group.kubernetes_api.id], var.extra_security_group_ids)

  tags = merge(var.tags, local.cluster_required_tags, {
    Role = "control-plane"
  })
}

#------------------------------------------------------------------------------
# Workers — ASG with launch template for cluster autoscaler
# Machine config passed as userdata — workers self-configure on boot
#------------------------------------------------------------------------------

resource "aws_launch_template" "worker" {
  name_prefix   = "${var.cluster_name}-worker-"
  image_id      = local.ami_id
  instance_type = var.worker_instance_type
  user_data     = base64encode(data.talos_machine_configuration.worker.machine_configuration)

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip
    security_groups             = concat([aws_security_group.cluster.id], var.extra_security_group_ids)
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.worker_volume_size
      volume_type = "gp3"
      encrypted   = true
    }
  }

  metadata_options {
    instance_metadata_tags = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, local.cluster_required_tags, {
      Name = "${var.cluster_name}-worker"
      Role = "worker"
    })
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "workers" {
  name                = "${var.cluster_name}-workers"
  min_size            = var.worker_min
  max_size            = var.worker_max
  desired_capacity    = var.worker_desired
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.worker.id
    version = "$Latest"
  }

  tag {
    key                 = "KubernetesCluster"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/enabled"
    value               = "true"
    propagate_at_launch = false
  }

  tag {
    key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
    value               = "owned"
    propagate_at_launch = false
  }

  lifecycle {
    ignore_changes = [desired_capacity]
  }
}

#------------------------------------------------------------------------------
# NLB — optional Kubernetes API load balancer
#------------------------------------------------------------------------------

resource "aws_lb" "kubernetes_api" {
  count = var.enable_nlb ? 1 : 0

  name               = "${var.cluster_name}-k8s"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  tags = merge(local.tags, local.cluster_required_tags, {
    Name = "${var.cluster_name}-k8s-api"
  })
}

resource "aws_lb_target_group" "kubernetes_api" {
  count = var.enable_nlb ? 1 : 0

  name     = "${var.cluster_name}-k8s"
  port     = 6443
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "TCP"
    port                = 6443
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = local.tags
}

resource "aws_lb_listener" "kubernetes_api" {
  count = var.enable_nlb ? 1 : 0

  load_balancer_arn = aws_lb.kubernetes_api[0].arn
  port              = 443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kubernetes_api[0].arn
  }

  tags = local.tags
}

resource "aws_lb_target_group_attachment" "control_plane" {
  count = var.enable_nlb ? var.control_plane_count : 0

  target_group_arn = aws_lb_target_group.kubernetes_api[0].arn
  target_id        = module.control_plane[count.index].id
  port             = 6443
}

#------------------------------------------------------------------------------
# Talos machine secrets + config generation
#------------------------------------------------------------------------------

resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version_contract
  kubernetes_version = var.kubernetes_version
  docs               = false
  examples           = false

  config_patches = concat(
    local.all_config_patches,
    var.control_plane_config_patches,
  )
}

data "talos_machine_configuration" "worker" {
  cluster_name       = var.cluster_name
  cluster_endpoint   = local.cluster_endpoint
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version_contract
  kubernetes_version = var.kubernetes_version
  docs               = false
  examples           = false

  config_patches = concat(
    local.all_config_patches,
    var.worker_config_patches,
  )
}

#------------------------------------------------------------------------------
# Apply config to control plane nodes + bootstrap
# (Workers get config via launch template userdata — no apply needed)
#------------------------------------------------------------------------------

resource "talos_machine_configuration_apply" "controlplane" {
  count = var.control_plane_count

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  endpoint                    = var.associate_public_ip ? module.control_plane[count.index].public_ip : module.control_plane[count.index].private_ip
  node                        = module.control_plane[count.index].private_ip
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.associate_public_ip ? module.control_plane[0].public_ip : module.control_plane[0].private_ip
  node                 = module.control_plane[0].private_ip
}

#------------------------------------------------------------------------------
# Retrieve cluster credentials
#------------------------------------------------------------------------------

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration

  endpoints = var.associate_public_ip ? module.control_plane[*].public_ip : module.control_plane[*].private_ip

  nodes = module.control_plane[*].private_ip
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on = [talos_machine_bootstrap.this]

  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = var.associate_public_ip ? module.control_plane[0].public_ip : module.control_plane[0].private_ip
  node                 = module.control_plane[0].private_ip
}

#------------------------------------------------------------------------------
# Store kubeconfig in Secrets Manager for cross-state consumption
# Pattern: data.aws_secretsmanager_secret_version → jsondecode → provider "kubernetes"
#------------------------------------------------------------------------------

resource "aws_secretsmanager_secret" "kubeconfig" {
  name        = "${var.cluster_name}/kubeconfig"
  description = "Kubeconfig for ${var.cluster_name} Talos cluster"
  tags        = local.tags
}

resource "aws_secretsmanager_secret_version" "kubeconfig" {
  secret_id = aws_secretsmanager_secret.kubeconfig.id

  secret_string = jsonencode({
    kubeconfig_raw              = talos_cluster_kubeconfig.this.kubeconfig_raw
    host                        = local.cluster_endpoint
    client_certificate_data     = talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate
    client_key_data             = talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key
    cluster_ca_certificate_data = talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate
  })
}

resource "aws_ssm_parameter" "talosconfig" {
  name        = "/${var.cluster_name}/talosconfig"
  description = "Talosconfig for ${var.cluster_name} (talosctl client config — endpoints + nodes baked in)"
  type        = "SecureString"
  value       = data.talos_client_configuration.this.talos_config

  tags = local.tags
}

