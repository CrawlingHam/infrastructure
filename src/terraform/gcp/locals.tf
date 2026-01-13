locals {
    gcp_labels = {
        for key, value in var.labels : lower(key) => value
    }
}