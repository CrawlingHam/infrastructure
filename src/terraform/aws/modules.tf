module "iam" {
    aws_ses_sender_identity = var.aws_ses_sender_identity
    vercel_team_slug = var.vercel_team_slug
    tags = var.tags
    source = "./iam"
}

module "s3" {
    project_name = var.project_name
    source = "./s3"
    tags = var.tags
}