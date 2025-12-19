provider "google" {
  	region      = var.gcp_region
}

provider "google-beta" {
	region                = var.gcp_region
	user_project_override = true
}

provider "google-beta" {
	alias 				  = "no_user_project_override"
	region                = var.gcp_region
	user_project_override = false
}

provider "aws" {
	region                = var.aws_region
}
