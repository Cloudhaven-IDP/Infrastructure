
locals {
  user_data_script = file("${path.module}/bootstrap.sh")
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                   = var.name
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet, 0)
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data_script != null ? var.user_data_script : local.user_data_script
  monitoring             = var.enable_monitoring
  create_eip = var.create_eip

  tags = merge({
    Name = var.name
  }, var.tags)
}
