module "aws" {
    aws_ses_sender_identity = local.aws_ses_sender_identity
    vercel_team_slug = local.vercel_team_slug
    project_name = local.project_name
    tags = local.common_tags
    source = "./aws"
}

module "gcp" {
    google_oauth_client_secret = local.google_oauth_client_secret
    capitalized_project_name = local.capitalized_project_name
    google_oauth_client_id = local.google_oauth_client_id
    billing_account_id = local.gcp_billing_account_id
    project_name = local.project_name
    domain_name = local.domain_name
    labels = local.common_tags
    source = "./gcp"

    providers = {
        google-beta                          = google-beta
        google-beta.no_user_project_override = google-beta.no_user_project_override
    }
}