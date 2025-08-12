module "request_ecr" {
  source = "../../../../modules/aws/ecr"

  name = "cloudhaven-frontend-ecr"
  tags = local.default_tags

  
}