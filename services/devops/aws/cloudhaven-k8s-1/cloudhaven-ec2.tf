data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }
}


data "aws_subnet" "subnet-private" {
  id = "subnet-08e4f7a91163d50c7" #need to find way around

}



module "cloudhaven-ec2-master" {
  source = "../../../../modules/aws/ec2/"

  name               = "cloudhaven-ec2-instance"
  iam_role_name      = "cloudhaven-ec2-instance-role"
  ami_id             = data.aws_ami.ubuntu.id
  subnet             = [data.aws_subnet.subnet-private.id]
  instance_type      = "t4g.small"
  security_group_ids = ["sg-0982ce650526b7543"]

  create_eip = false


}


module "cloudhaven-ec2-slave" {
  source = "../../../../modules/aws/ec2/"

  name               = "cloudhaven-ec2-instance-2"
  iam_role_name      = "cloudhaven-ec2-instance-role-2"
  ami_id             = data.aws_ami.ubuntu.id
  subnet             = [data.aws_subnet.subnet-private.id]
  instance_type      = "t4g.xlarge"
  security_group_ids = ["sg-0982ce650526b7543"]

  create_eip = false


}