module "role" {
    aws_ses_sender_identity = var.aws_ses_sender_identity
    vercel_team_slug = var.vercel_team_slug
    source = "./role"
    tags = var.tags
}