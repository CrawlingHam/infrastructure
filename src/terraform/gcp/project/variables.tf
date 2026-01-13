variable "billing_account_id" {
    type = string
}

variable "name" {
    type = string
}

variable "id" {
    type = string
}

variable "labels" {
    type = map(string)
}

variable "services" {
    type = list(string)
}

variable "service_account_name" {
    type = string
    default = ""
}

variable "service_account" {
    default = false
    type = bool
}

variable "service_account_description" {
    type = string
    default = ""
}

variable "service_account_id" {
    type = string
    default = ""
}