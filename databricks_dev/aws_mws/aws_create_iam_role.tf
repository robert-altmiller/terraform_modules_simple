# AWS IAM role creation
resource "aws_iam_role" "cross_account_role" {
  name               = local.vars.aws.iam.role_name
  #assume_role_policy = data.aws_iam_policy_document.workspace_role_assume_role.json
  #inline_policy {
  #  name   = "databricks_workspace_policy"
  #  policy = data.aws_iam_policy_document.workspace_role_inline_policy.json
  #}
  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  tags               = local.vars.aws.iam.role_tags
}