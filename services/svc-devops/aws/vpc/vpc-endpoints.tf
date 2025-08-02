locals {
  endpoints = [
    "s3",
    "dynamodb",
    "apigateway"
  ]
}

resource "aws_vpc_endpoint" "this" {
  for_each = toset(local.endpoints)

  vpc_id       = module.cloudhaven-vpc.vpc_id
  service_name = "com.amazonaws.${local.config.Region}.${each.key}"

  vpc_endpoint_type = "Interface"
}
