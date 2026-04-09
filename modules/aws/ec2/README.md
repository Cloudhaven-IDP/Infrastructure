# ec2

Generic EC2 instance module. Used for both Tailscale subnet routers and Talos cluster nodes.

## Usage — Tailscale subnet router

```hcl
module "tailscale_router" {
  source = "../../../modules/aws/ec2"

  name          = "humboldt-tailscale"
  environment   = local.config.environment
  ami_id        = data.aws_ami.al2023.id
  instance_type = "t4g.nano"
  subnet_id     = module.vpc.private_subnets[0]

  security_group_ids   = [aws_security_group.tailscale.id]
  iam_instance_profile = aws_iam_instance_profile.tailscale.name
  source_dest_check    = false   # required for subnet routing

  user_data = templatefile("${path.module}/templates/tailscale.sh.tpl", {
    auth_key = data.aws_secretsmanager_secret_version.tailscale.secret_string
    routes   = "10.0.0.0/16"
  })
}
```

## Usage — Talos cluster node

```hcl
module "control_plane" {
  source = "../../../modules/aws/ec2"

  name          = "humboldt-cp-1"
  environment   = local.config.environment
  ami_id        = var.talos_ami_id
  instance_type = "t4g.medium"
  subnet_id     = module.vpc.private_subnets[0]

  security_group_ids = [aws_security_group.talos.id]
  root_volume_size   = 50

  # Talos doesn't use SSH
  key_name = null
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Instance name | string | - | yes |
| environment | Environment (dev, staging, prod) | string | - | yes |
| ami_id | AMI ID | string | - | yes |
| instance_type | EC2 instance type | string | - | yes |
| subnet_id | Subnet to launch in | string | - | yes |
| security_group_ids | Security group IDs | list(string) | - | yes |
| iam_instance_profile | IAM instance profile name | string | `null` | no |
| user_data | Startup script | string | `null` | no |
| associate_public_ip | Attach public IP | bool | `false` | no |
| source_dest_check | Enable source/dest check (false for routers) | bool | `true` | no |
| root_volume_size | Root volume size in GB | number | `20` | no |
| root_volume_type | Root volume type | string | `gp3` | no |
| root_volume_encrypted | Encrypt root volume | bool | `true` | no |
| key_name | SSH key pair name | string | `null` | no |
| tags | Additional tags | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Instance ID |
| arn | Instance ARN |
| private_ip | Private IP address |
| public_ip | Public IP (null if no public IP) |
