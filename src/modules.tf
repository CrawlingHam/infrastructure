module "aws" {
    project_name = var.project_name
    tags = local.common_tags
    source = "./aws"
}