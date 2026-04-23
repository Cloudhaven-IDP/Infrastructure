module "ecr_dev" {
  source          = "../../../modules/aws/ecr"
  repository_name = "afolabi-next-dev"
}

module "ecr_prod" {
  source          = "../../../modules/aws/ecr"
  repository_name = "afolabi-next-prod"
}
