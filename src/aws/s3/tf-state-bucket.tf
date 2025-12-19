module "tf-state-bucket" {
    name = "${var.project_name}-terraform-state"
    rule_id = "terraform_state_lifecycle"
    encryption_algorithm = "AES256"
    public_access_block = true
    days_after_initiation = 7
    noncurrent_days = 30
    source = "./bucket"
    encryption = true
    versioning = true
    tags = var.tags
    prefix = ""
}