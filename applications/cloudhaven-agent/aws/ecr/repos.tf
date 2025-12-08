module "ecr_repository" {
  source = "../../../../modules/aws/ecr"
  repository_name = "cloudhaven-agent"
}