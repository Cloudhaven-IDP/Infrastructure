#------------------------------------------------------------------------------
# Tailscale subnet router — t4g.nano, advertises VPC CIDR to Tailscale mesh
#------------------------------------------------------------------------------

module "tailscale" {
  source = "../../../modules/aws/ec2"

  name          = "nebulosa-humboldt-tailnet-router"
  environment   = local.config.environment
  ami_id        = data.aws_ami.al2023_arm.id
  instance_type = "t4g.nano"
  subnet_id     = module.vpc.private_subnets[0]
  vpc_id        = module.vpc.vpc_id

  source_dest_check = false

  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  inline_policies = {
    tailscale-ssm = data.aws_iam_policy_document.tailscale_ssm.json
  }

  user_data = templatefile("${path.module}/templates/tailscale.sh", {
    parameter_name   = data.aws_ssm_parameter.tailscale_auth_key.name
    region           = local.config.region
    advertise_routes = "10.0.0.0/16"
    hostname         = "nebulosa-humboldt-tailnet-router"
  })
}
