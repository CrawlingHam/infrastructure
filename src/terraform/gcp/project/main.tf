resource "google_project" "project" {
    provider        = google-beta.no_user_project_override
    billing_account = var.billing_account_id
    labels          = var.labels
    name            = var.name
    deletion_policy = "DELETE"
    project_id      = var.id
}

resource "google_project_service" "project" {
    provider   = google-beta.no_user_project_override
    project    = google_project.project.project_id
    depends_on = [google_project.project]

    for_each   = toset(concat([
        "cloudresourcemanager.googleapis.com", # Cloud Resource Manager API
        "cloudbilling.googleapis.com",         # Cloud Billing API
        "serviceusage.googleapis.com",         # Service Usage API
    ], var.services))

    service    = each.key
}

resource "google_service_account" "project_service_account" {
    project      = google_project.project.project_id
    depends_on   = [google_project_service.project]
    description  = var.service_account_description
    count        = var.service_account ? 1 : 0
    display_name = var.service_account_name
    account_id   = var.service_account_id
}