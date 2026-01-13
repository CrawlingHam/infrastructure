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
        bucket = local.terraform_state_bucket
        key    = local.terraform_state_key
        region = local.aws_region
    }
}
