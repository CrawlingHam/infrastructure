module "iam" {
    source = "./iam"
}

module "s3" {
    project_name = var.project_name
    source = "./s3"
    tags = var.tags
}