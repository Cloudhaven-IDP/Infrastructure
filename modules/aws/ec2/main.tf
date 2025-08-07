data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }
}

locals {
  user_data_script = file("${path.module}/bootstrap.sh")
  ami_id           = data.aws_ami.ubuntu.id
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                   = var.name
  ami                    = coalesce(var.ami_id, local.ami_id)
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data_script != null ? var.user_data_script : local.user_data_script
  monitoring             = var.enable_monitoring
  create_eip             = var.create_eip

  tags = merge({
    Name = var.name
  }, var.tags)
}
