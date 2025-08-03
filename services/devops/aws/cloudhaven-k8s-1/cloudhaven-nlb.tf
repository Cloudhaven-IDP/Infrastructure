data "aws_subnet" "subnet-public" {
  id = "subnet-09c486f4df52b683a"

}

module "cloudhaven-nlb" {
  source             = "../../../../modules/aws/nlb"
  name               = "cloudhaven-nlb"
  subnet_ids         = [data.aws_subnet.subnet-public.id]
  target_instance_id = module.cloudhaven-ec2-slave.instance_id
  type               = "network"

  tags = {
    Name = "cloudhaven-nlb"
  } 
}