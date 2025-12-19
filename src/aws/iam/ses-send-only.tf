module "ses-send-only-user" {
    name = "ses-send-only"
    source = "./user"
}

module "ses-send-only-policy" {
    user_name = module.ses-send-only-user.name
    policy_name = "ses-send-only-policy"
    policy_file = "ses_send.json"
    source = "./policy"
    
    depends_on = [ module.ses-send-only-user ]
}
