variable "name" {
    type = string
}

variable "tags" {
    type = map(string)
}

variable "versioning" {
    type = bool
}

variable "encryption" {
    type = bool
}

variable "encryption_algorithm" {
    type = string
}

variable "public_access_block" {
    type = bool
}

variable "rule_id" {
    type = string
}

variable "prefix" {
    type = string
}

variable "noncurrent_days" {
    type = number
}

variable "days_after_initiation" {
    type = number
}