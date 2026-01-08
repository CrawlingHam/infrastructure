variable "project_name" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "vercel_team_slug" {
    type = string
}

variable "aws_ses_sender_identity" {
    type = string
}