resource "aws_iam_user_policy" "policy" {
    policy = file("${path.module}/${var.policy_file}")
    name = var.policy_name
    user = var.user_name
}
