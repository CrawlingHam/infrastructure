provider "google" {
  	region      = local.gcp_region
}

provider "google-beta" {
	region                = local.gcp_region
	user_project_override = true
}

provider "google-beta" {
	alias 				  = "no_user_project_override"
	region                = local.gcp_region
	user_project_override = false
}

provider "aws" {
	region                = local.aws_region
}
