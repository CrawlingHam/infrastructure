module "github" {
    github_repos = ["repo:*"]
    source = "./github"
    tags = var.tags
}

module "vercel" {
    aws_ses_sender_identity = var.aws_ses_sender_identity
    vercel_team_slug = var.vercel_team_slug
    source = "./vercel"
    tags = var.tags
}