resource "google_apikeys_key" "api_key" {
    display_name              = var.display_name
    project                   = var.project_id
    provider                  = google-beta
    name                      = var.name

    restrictions {
        api_targets {
            service           = var.service
        }

        browser_key_restrictions {
            allowed_referrers = var.allowed_referrers
        }
    }
}
