locals {
    account_id = data.aws_caller_identity.current.account_id
    region = data.aws_region.current.region
}

resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"

    client_id_list = [
        "sts.amazonaws.com"
    ]
    
    thumbprint_list = [
        "3cdb4a3846d00f190fbae52af10db518c5e6039c"
    ]
}

resource "aws_iam_role" "github" {
    name = "github-oidc-ecr-push"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Federated = aws_iam_openid_connect_provider.github.arn
                }
                Action = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
                    }
                    StringLike = {
                        "token.actions.githubusercontent.com:sub" = var.github_repos
                    }
                }
            }
        ]
    })

    tags = var.tags
}

resource "aws_iam_role_policy" "github" {
    name = aws_iam_role.github.name
    role = aws_iam_role.github.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:GetAuthorizationToken",
                    "ecr:InitiateLayerUpload",
                    "ecr:CompleteLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:BatchGetImage",
                    "ecr:PutImage",
                ]
                Resource = ["arn:aws:ecr:${local.region}:${local.account_id}:repository/*"]
            },
            {
                Effect = "Allow"
                Action = [
                    "ecr:GetAuthorizationToken",
                ]
                Resource = ["*"]
            },
            {
                Effect = "Allow"
                Action = [
                    "lambda:GetFunctionConfiguration",
                    "lambda:UpdateFunctionCode",
                    "lambda:GetFunction",
                ]
                Resource = ["arn:aws:lambda:${local.region}:${local.account_id}:function:*"]
            }
        ]
    })
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}