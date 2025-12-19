resource "aws_s3_bucket" "bucket" {
    bucket = var.name
    tags = var.tags
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
    bucket     = aws_s3_bucket.bucket.id

    versioning_configuration {
        status = var.versioning ? "Enabled" : "Disabled"
    }

    depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aes256" {
    bucket     = aws_s3_bucket.bucket.id

    rule {
        bucket_key_enabled = var.encryption
        apply_server_side_encryption_by_default {
            sse_algorithm = var.encryption_algorithm
        }
    }

    depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_public_access_block" "public" {
    count                   = var.public_access_block ? 1 : 0
    bucket                  = aws_s3_bucket.bucket.id

    restrict_public_buckets = true
    block_public_policy     = true
    ignore_public_acls      = true
    block_public_acls       = true

    depends_on              = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_lifecycle_configuration" "basic" {
    bucket     = aws_s3_bucket.bucket.id

    rule {
        id     = var.rule_id
        status = "Enabled"

        filter {
            prefix = var.prefix
        }

        noncurrent_version_expiration {
            noncurrent_days = var.noncurrent_days
        }

        abort_incomplete_multipart_upload {
            days_after_initiation = var.days_after_initiation
        }
    }

    depends_on = [aws_s3_bucket.bucket]
}
