# AWS S3 bucket
resource "aws_s3_bucket" "root_storage_bucket" {
  bucket = local.vars.aws.s3.bucket_name
  tags   = local.vars.aws.s3.tags
  force_destroy = true
}

# AWS S3 bucket server side encryption configurtion
resource "aws_s3_bucket_server_side_encryption_configuration" "root_storage_bucket" {
  depends_on = [aws_s3_bucket.root_storage_bucket]
  bucket = aws_s3_bucket.root_storage_bucket.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# AWS S3 bucket block public access
resource "aws_s3_bucket_public_access_block" "root_storage_bucket" {
  depends_on              = [aws_s3_bucket.root_storage_bucket]
  bucket                  = aws_s3_bucket.root_storage_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Databricks AWS bucket policy
data "databricks_aws_bucket_policy" "this" {
  bucket = aws_s3_bucket.root_storage_bucket.bucket
}

# AWS S3 bucket policy
resource "aws_s3_bucket_policy" "root_bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.root_storage_bucket]
  bucket     = aws_s3_bucket.root_storage_bucket.id
  policy     = data.databricks_aws_bucket_policy.this.json
}

# AWS S3 bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "root_storage_bucket_ownership" {
  depends_on = [aws_s3_bucket.root_storage_bucket]
  bucket = aws_s3_bucket.root_storage_bucket.id
  rule {
    object_ownership = local.vars.aws.s3.object_ownership
  }
}

# AWS S3 bucket versioning
resource "aws_s3_bucket_versioning" "root_bucket_versioning" {
  depends_on = [aws_s3_bucket.root_storage_bucket]
  bucket = aws_s3_bucket.root_storage_bucket.id
  versioning_configuration {
    status = local.vars.aws.s3.versioning
  }
}