provider "aws" {
    region = var.region
}

#KMS
resource "aws_kms_key" "s3" {
    description = "KMS for s3 encryption"
    deletion_window_in_days = 7
    enable_key_rotation = true
}

#S3 Bucket
resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name

    tags = {
        Environment = var.environment
        ManagedBy = "Terraform"
    }
}

#Block Public Access
resource "aws_s3_bucket_public_access_block" "this"{
    bucket = aws_s3_bucket.this.id

    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

#Ownership
resource "aws_s3_bucket_ownership_controls" "this" {
    bucket = aws_s3_bucket.this.id
    rule {
        object_ownership = "BucketOwnerEnforced"
    }
}

#versioning
resource "aws_s3_bucket_versioning" "this" {
     bucket = aws_s3_bucket.this.id
     versioning_configuration {
       status = "Enabled"
     }
}

#Lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "this" {
    bucket = aws_s3_bucket.this.id
    rule {
        id = "cleanup"
        status = "Enabled"

        noncurrent_version_expiration {
          noncurrent_days = 30
        }
    }
}