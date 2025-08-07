data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }
}



data "aws_subnet" "subnet-private" {
  id = "subnet-08e4f7a91163d50c7" #need to find way around

}



module "cloudhaven-ec2-master" {
  source = "../../../../modules/aws/ec2/"

  name          = "cloudhaven-k8s-master"
  instance_type = "t4g.small"
  create_eip    = false
}


# module "cloudhaven-ec2-slave" {
#   source = "../../../../modules/aws/ec2/"
#   instance_type = "t4g.xlarge"

#   name               = "cloudhaven-k8s-worker"
#   create_eip = false
# }