# Create IAM role with initial assume role policy
resource "aws_iam_role" "external_assume_role" {
  name = local.vars.dbricks.sc.sc_iam_role_external_assume
  assume_role_policy = local.assume_role_policy_json
}

# Update the IAM role with the final assume role policy updates
resource "null_resource" "update_external_assume_policy" {
  depends_on = [aws_iam_role.external_assume_role, aws_iam_policy.s3_policy, time_sleep.wait_120_seconds]
  triggers = {
    role_id      = aws_iam_role.external_assume_role.id
    policy_id    = aws_iam_policy.s3_policy.id
    role_version = md5(jsonencode(local.assume_role_policy_updated_json))
    # role_version = md5(jsonencode(aws_iam_role.external_assume_role.assume_role_policy))
  }
  provisioner "local-exec" {
    command = <<-EOT
      AWS_ACCESS_KEY_ID=${local.vars.aws.conn.access_key} \
      AWS_SECRET_ACCESS_KEY=${local.vars.aws.conn.access_key_secret} \
      AWS_DEFAULT_REGION=${local.vars.aws.conn.region} \
      aws iam update-assume-role-policy \
        --role-name ${aws_iam_role.external_assume_role.name} \
        --policy-document '${local.assume_role_policy_updated_json}'
    EOT
  }
}

# Wait for 120 seconds
resource "time_sleep" "wait_120_seconds" {
  create_duration = "120s"
}

# Used with Storage Credentials Terraform module
output "aws_iam_role_arn_for_databricks_storage_creds" {
  value = aws_iam_role.external_assume_role.arn
}