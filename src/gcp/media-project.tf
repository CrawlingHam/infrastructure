module "media-project" {
    name = "${var.capitalized_project_name} Media"
    billing_account_id = var.billing_account_id
    id = "${var.project_name}-media-f42fc023"
    source = "./project"

    services = [
        "youtube.googleapis.com",              # YouTube Data API
        "apikeys.googleapis.com",             # API Keys API
    ]
    
    labels = merge(local.gcp_labels, {
        "youtube" = "enabled"
    })

    providers = {
        google-beta                          = google-beta
        google-beta.no_user_project_override = google-beta.no_user_project_override
    }
}

module "youtube-api-key" {
    display_name = "YouTube Data API Key (Browser)"
    project_id = module.media-project.project_id
    name = "youtube-data-api-key-browser"
    service = "youtube.googleapis.com"
    allowed_referrers = []
    source = "./api-keys"

    providers = {
        google-beta                          = google-beta
        google-beta.no_user_project_override = google-beta.no_user_project_override
    }

    depends_on = [ 
        module.media-project
     ]
}