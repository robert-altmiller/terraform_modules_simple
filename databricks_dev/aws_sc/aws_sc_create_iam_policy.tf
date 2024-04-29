# Attach a user to an IAM policy
resource "aws_iam_user_policy_attachment" "this" {
  depends_on = [aws_iam_policy.s3_policy]
  user       = local.vars.dbricks.conn.user_name
  policy_arn = aws_iam_policy.s3_policy.arn
}


# Attach an IAM policy to an IAM role
resource "aws_iam_policy_attachment" "this" {
  depends_on = [aws_iam_role.external_assume_role, aws_iam_policy.s3_policy]
  name       = "attach_policy_to_role"
  roles      = [aws_iam_role.external_assume_role.name]
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Create an IAM policy for Databricks storage credentials
resource "aws_iam_policy" "s3_policy" {
  depends_on = [aws_iam_role.external_assume_role]
  name        = local.vars.dbricks.sc.sc_iam_policy_name
  description = "AWS IAM policy for Databricks storage credentials"
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject",
                "s3:ListBucket",
                "s3:DeleteBucket",
                "s3:GetBucketLocation",
                "s3:GetLifecycleConfiguration",
                "s3:PutLifecycleConfiguration",
                "s3:CreateBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.dev.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.dev.bucket}",
                "arn:aws:s3:::${aws_s3_bucket.test.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.test.bucket}",
                "arn:aws:s3:::${aws_s3_bucket.prod.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.prod.bucket}",
                "arn:aws:s3:::${aws_s3_bucket.uc.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.uc.bucket}"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.external_assume_role.name}"
            ],
            "Effect": "Allow"
        }
    ]
}
EOT
}