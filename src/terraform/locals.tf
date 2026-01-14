locals {
    env_file_path = "${path.module}/../../.env"
    env_file_exists = try(fileexists(local.env_file_path), false)
    
    env_file_lines = local.env_file_exists ? [
        for line in split("\n", file(local.env_file_path)) :
        trimspace(line)
    ] : []
    
    parsed_env_vars_raw = [
        for line in local.env_file_lines :
        {
            key   = trimspace(split("=", line)[0])
            value = length(split("=", line)) > 1 ? trimspace(join("=", slice(split("=", line), 1, length(split("=", line))))) : ""
        }
        if length(line) > 0 && substr(line, 0, 1) != "#" && length(split("=", line)) >= 2 && length(trimspace(split("=", line)[0])) > 0
    ]
    
    initial_env_vars_map = {
        for env in local.parsed_env_vars_raw :
        env.key => env.value
    }
    
    default_env = [
        {
            target = ["production"]
            key    = "NODE_VERSION"
            value  = "18"
        }
    ]
    
    env_from_file = [
        for key, value in local.initial_env_vars_map : {
            value  = replace(replace(value, "\"", ""), "'", "")
            target = ["production"]
            key    = key
        }
    ]
    
    env_vars = concat(local.default_env, local.env_from_file)
    env_vars_map = {
        for env in local.env_vars :
        env.key => env.value
    }

    google_oauth_client_secret = local.env_vars_map["GOOGLE_OAUTH_CLIENT_SECRET"]
    aws_ses_sender_identity = local.env_vars_map["AWS_SES_SENDER_IDENTITY"]
    gcp_billing_account_id = local.env_vars_map["GCP_BILLING_ACCOUNT_ID"]
    terraform_state_bucket = local.env_vars_map["TERRAFORM_STATE_BUCKET"]
    google_oauth_client_id = local.env_vars_map["GOOGLE_OAUTH_CLIENT_ID"]
    terraform_state_key = local.env_vars_map["TERRAFORM_STATE_KEY"]
    vercel_team_slug = local.env_vars_map["VERCEL_TEAM_SLUG"]
    project_name = local.env_vars_map["PROJECT_NAME"]
    environment = local.env_vars_map["ENVIRONMENT"]
    domain_name = local.env_vars_map["DOMAIN_NAME"]
    maintainer = local.env_vars_map["MAINTAINER"]
    aws_region = local.env_vars_map["AWS_REGION"]
    gcp_region = local.env_vars_map["GCP_REGION"]

    capitalized_project_name = format(
        "%s%s",
        upper(substr(local.project_name, 0, 1)),
        substr(local.project_name, 1, length(local.project_name))
    )

    common_tags = {
        Environment = local.environment
        Project = local.project_name
        Maintainer = local.maintainer
    }
}

