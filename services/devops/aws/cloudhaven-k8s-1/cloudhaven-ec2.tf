data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# data "aws_subnet" "private_subnet" {
#   id = "subnet-08e4f7a91163d50c7" #need to find way around

# }


module "cloudhaven-ec2" {
  source = "../../../../modules/aws/ec2/"

  name          = "cloudhaven-ec2-instance"
  iam_role_name = "cloudhaven-ec2-instance-role"
  ami_id        = data.aws_ami.ubuntu.id
  subnet        = [data.aws_subnet.subnet-public.id]
  instance_type = "t3.medium"
  security_group_ids = [ ]

  create_eip = false


}