module "core-project" {
    name = "${var.capitalized_project_name} Core"
    billing_account_id = var.billing_account_id
    id = "${var.project_name}-core-7922d5f5"
    labels = local.gcp_labels
    source = "./project"
    services = []

    providers = {
        google-beta                          = google-beta
        google-beta.no_user_project_override = google-beta.no_user_project_override
    }
}