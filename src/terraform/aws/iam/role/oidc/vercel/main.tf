locals {
    account_id = data.aws_caller_identity.current.account_id
    region = data.aws_region.current.region
}

resource "aws_iam_openid_connect_provider" "vercel" {
    url = "https://oidc.vercel.com/${var.vercel_team_slug}"

    client_id_list = [
        "https://vercel.com/${var.vercel_team_slug}"
    ]
    
    thumbprint_list = [
        "3c6ddb4a3840f00f19bae510db5160398c52afec"
    ]
}

resource "aws_iam_role" "vercel" {
    name = "vercel-oidc"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Federated = aws_iam_openid_connect_provider.vercel.arn
                }
                Action = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringEquals = {
                        "oidc.vercel.com/${var.vercel_team_slug}:aud" = "https://vercel.com/${var.vercel_team_slug}"
                    }
                    StringLike = {
                        "oidc.vercel.com/${var.vercel_team_slug}:sub" = [
                            "owner:${var.vercel_team_slug}:project:*:environment:production",
                        ]
                    }
                }
            }
        ]
    })

    tags = var.tags
}

resource "aws_iam_role_policy" "vercel" {
    name = aws_iam_role.vercel.name
    role = aws_iam_role.vercel.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ses:SendTemplatedEmail",
                    "ses:SendRawEmail",
                    "ses:SendEmail",
                ]
                Resource = ["arn:aws:ses:${local.region}:${local.account_id}:identity/${var.aws_ses_sender_identity}"]
            }
        ]
    })
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}