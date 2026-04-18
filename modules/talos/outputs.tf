output "kubeconfig" {
  description = "Raw kubeconfig YAML for the Talos cluster"
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "talosconfig" {
  description = "Talosconfig for talosctl access"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "cluster_endpoint" {
  description = "Kubernetes API endpoint"
  value       = local.cluster_endpoint
}

output "kubeconfig_secret_arn" {
  description = "ARN of the Secrets Manager secret storing kubeconfig (for cross-state consumption)"
  value       = aws_secretsmanager_secret.kubeconfig.arn
}

output "control_plane_ips" {
  description = "Private IPs of control plane nodes"
  value       = module.control_plane[*].private_ip
}

output "control_plane_public_ips" {
  description = "Public IPs of control plane nodes (null if associate_public_ip is false)"
  value       = module.control_plane[*].public_ip
}

output "worker_asg_name" {
  description = "Name of the worker ASG (for cluster autoscaler discovery)"
  value       = aws_autoscaling_group.workers.name
}

output "cluster_security_group_id" {
  description = "Security group ID for intra-cluster traffic"
  value       = aws_security_group.cluster.id
}

output "kubernetes_api_security_group_id" {
  description = "Security group ID for Kubernetes API access"
  value       = aws_security_group.kubernetes_api.id
}

output "nlb_dns_name" {
  description = "DNS name of the Kubernetes API NLB (null if NLB disabled)"
  value       = var.enable_nlb ? aws_lb.kubernetes_api[0].dns_name : null
}

output "machine_secrets" {
  description = "Talos machine secrets (needed for cluster operations)"
  value       = talos_machine_secrets.this.machine_secrets
  sensitive   = true
}
