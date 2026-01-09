module "firebase-project" {
    name               = "${var.capitalized_project_name} Firebase"
    id                 = "${var.project_name}-firebase-713ae908"
    billing_account_id = var.billing_account_id
    source             = "./project"

    services = [
        "identitytoolkit.googleapis.com",      # Identity Toolkit API
        "firebase.googleapis.com",             # Firebase API
    ]

    labels = merge(local.gcp_labels, {
        "firebase" = "enabled"
    })

    providers = {
        google-beta                          = google-beta
        google-beta.no_user_project_override = google-beta.no_user_project_override
    }
}

resource "google_firebase_project" "project" {
    project  = module.firebase-project.project_id
    provider = google-beta

    depends_on = [
        module.firebase-project
    ]
}

resource "google_firebase_web_app" "web-app" {
    display_name = "${module.firebase-project.project_name} Web App"
    project      = module.firebase-project.project_id
    provider     = google-beta
    

    depends_on = [
        google_firebase_project.project,
        module.firebase-project
    ]
}

resource "google_service_account" "firebase-admin-sdk" {
    display_name = "${module.firebase-project.project_name} Admin SDK Service Account"
    account_id   = module.firebase-project.project_id
    project      = module.firebase-project.project_id
    provider     = google-beta

    depends_on = [
        module.firebase-project
    ]
}

resource "google_project_iam_member" "firebase-admin-identity-toolkit" {
    member  = "serviceAccount:${google_service_account.firebase-admin-sdk.email}"
    project = module.firebase-project.project_id
    role    = "roles/identitytoolkit.admin"
    
    depends_on = [
        google_service_account.firebase-admin-sdk,
        google_firebase_project.project
    ]
}

resource "google_project_iam_member" "firebase-admin-firebase-admin" {
    member  = "serviceAccount:${google_service_account.firebase-admin-sdk.email}"
    project = module.firebase-project.project_id
    role    = "roles/firebase.admin"
    
    depends_on = [
        google_service_account.firebase-admin-sdk,
        google_firebase_project.project
    ]
}

resource "google_identity_platform_config" "firebase-auth-config" {
    project                    = module.firebase-project.project_id
    provider                   = google-beta
    autodelete_anonymous_users = true

    sign_in {
        allow_duplicate_emails = false
        email {
            password_required = true
            enabled = true
        }
        anonymous {
            enabled = true
        }
    }    

    quota {
        sign_up_quota_config {
            start_time     = formatdate("YYYY-MM-DD'T'hh:mm:ss'Z'", timestamp())
            quota_duration = "7200s"
            quota          = 100
        }
    }

    authorized_domains = [
        "${module.firebase-project.project_id}.firebaseapp.com",
        "${module.firebase-project.project_id}.web.app",
        var.domain_name,
        "localhost",
    ]

    depends_on = [
        google_firebase_project.project,
        module.firebase-project,
    ]
}

locals {
    identity_providers = [{
        client_secret = var.google_oauth_client_secret
        client_id    = var.google_oauth_client_id
        idp_id       = "google.com"
    }]
    
    identity_providers_map = {
        for idp in local.identity_providers : idp.idp_id => idp
    }
}

resource "google_identity_platform_default_supported_idp_config" "firebase-idp-config" {
    for_each      = local.identity_providers_map

    project       = module.firebase-project.project_id
    client_secret = each.value.client_secret
    client_id     = each.value.client_id
    idp_id        = each.value.idp_id
    provider      = google-beta
    enabled       = true
    
    depends_on = [
        google_firebase_project.project,
        module.firebase-project,
        google_identity_platform_config.firebase-auth-config
    ]
}