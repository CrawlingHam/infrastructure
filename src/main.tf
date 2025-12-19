terraform {
    required_version = ">=1.10.6"

    required_providers {
        google-beta = {
            source  = "hashicorp/google-beta"
            version = "~> 7.0"
        }
        google = {
            source  = "hashicorp/google"
            version = "~> 7.0"
        }
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket = "${var.project_name}-terraform-state"
        key    = "terraform.tfstate"
        region = var.aws_region
    }
}
