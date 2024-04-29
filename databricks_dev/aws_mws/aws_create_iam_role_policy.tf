# Databricks AWS cross account policy
data "databricks_aws_crossaccount_policy" "this" {
}

// IAM Role for workspace access
# data "aws_iam_policy_document" "workspace_role_assume_role" {
#   # Allow the IAM user to assume the role
#   statement {
#     effect = "Allow"
#     principals {
#       type = "AWS"
#       identifiers = ["arn:aws:iam::414351767826:user/ConsolidatedManagerIAMUser-ConsolidatedManagerUser-VX02FYW0SSCY"]
#     }
#     actions = ["sts:AssumeRole"]
#   }

#   # Allow the EC2 service to assume the role
#   statement {
#     effect = "Allow"
#     principals {
#       type = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# data "aws_iam_policy_document" "workspace_role_inline_policy" {
#   statement {
#     actions = [
#       "ec2:AssociateIamInstanceProfile", "ec2:AttachVolume", "ec2:AuthorizeSecurityGroupEgress",
#       "ec2:AuthorizeSecurityGroupIngress", "ec2:CancelSpotInstanceRequests", "ec2:CreateTags", "ec2:CreateVolume",
#       "ec2:DeleteTags", "ec2:DeleteVolume", "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeIamInstanceProfileAssociations", "ec2:DescribeInstanceStatus", "ec2:DescribeInstances",
#       "ec2:DescribeInternetGateways", "ec2:DescribeNatGateways", "ec2:DescribeNetworkAcls", "ec2:DescribePrefixLists",
#       "ec2:DescribeReservedInstancesOfferings", "ec2:DescribeRouteTables", "ec2:DescribeSecurityGroups",
#       "ec2:DescribeSpotInstanceRequests", "ec2:DescribeSpotPriceHistory", "ec2:DescribeSubnets", "ec2:DescribeVolumes",
#       "ec2:DescribeVpcAttribute", "ec2:DescribeVpcs", "ec2:DetachVolume", "ec2:DisassociateIamInstanceProfile",
#       "ec2:ReplaceIamInstanceProfileAssociation", "ec2:RequestSpotInstances", "ec2:RevokeSecurityGroupEgress",
#       "ec2:RevokeSecurityGroupIngress", "ec2:RunInstances", "ec2:TerminateInstances", "ec2:DescribeFleetHistory",
#       "ec2:ModifyFleet", "ec2:DeleteFleets", "ec2:DescribeFleetInstances", "ec2:DescribeFleets", "ec2:CreateFleet",
#       "ec2:DeleteLaunchTemplate", "ec2:GetLaunchTemplateData", "ec2:CreateLaunchTemplate",
#       "ec2:DescribeLaunchTemplates", "ec2:DescribeLaunchTemplateVersions", "ec2:ModifyLaunchTemplate",
#       "ec2:DeleteLaunchTemplateVersions", "ec2:CreateLaunchTemplateVersion", "ec2:AssignPrivateIpAddresses",
#       "ec2:GetSpotPlacementScores"
#     ]
#     resources = ["*"]
#   }
#   statement {
#     actions = [
#       "iam:CreateServiceLinkedRole", "iam:PutRolePolicy"
#     ]
#     resources = [
#       "arn:aws:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot"
#     ]
#     condition {
#       test     = "StringLike"
#       values   = ["spot.amazonaws.com"]
#       variable = "iam:AWSServiceName"
#     }
#   }
# }

# Databricks AWS assume role policy
data "databricks_aws_assume_role_policy" "this" {
  external_id = local.vars.dbricks.conn.account_id
}

# Create AWS Policy and attach it to an IAM role
resource "aws_iam_role_policy" "this" {
  name   = local.vars.aws.iam.role_policy_name
  role   = aws_iam_role.cross_account_role.id
  policy = data.databricks_aws_crossaccount_policy.this.json
}

# Attach and AWS policy to an IAM role
resource "aws_iam_policy_attachment" "this" {
  name       = "AmazonEC2FullAccess"
  roles      = [aws_iam_role.cross_account_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"  # Use this if attaching an existing AWS managed policy
}


