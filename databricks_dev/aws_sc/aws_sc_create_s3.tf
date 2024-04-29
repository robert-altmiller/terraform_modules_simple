resource "aws_s3_bucket" "dev" {
  bucket = local.vars.dbricks.sc.sc_s3_bucket_dev
  force_destroy = true
}

resource "aws_s3_bucket" "test" {
  bucket = local.vars.dbricks.sc.sc_s3_bucket_test
  force_destroy = true
}

resource "aws_s3_bucket" "prod" {
  bucket = local.vars.dbricks.sc.sc_s3_bucket_prod
  force_destroy = true
}

resource "aws_s3_bucket" "uc" {
  bucket = local.vars.dbricks.sc.sc_s3_bucket_uc
  force_destroy = true
}