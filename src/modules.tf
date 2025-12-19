module "aws" {
    project_name = var.project_name
    tags = local.common_tags
    source = "./aws"
}

module "gcp" {
    capitalized_project_name = var.capitalized_project_name
    billing_account_id = var.gcp_billing_account_id
    project_name = var.project_name
    labels = local.common_tags
    source = "./gcp"

    providers = {
        google-beta                          = google-beta
        google-beta.no_user_project_override = google-beta.no_user_project_override
    }
}