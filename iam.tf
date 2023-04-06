resource "aws_iam_access_key" "service_account" {
  user = aws_iam_user.service_account.name
}

resource "aws_iam_user" "service_account" {
  name = "${local.project}-service-account"
  path = "/system/"
}

resource "aws_iam_access_key" "ci_account" {
  user = aws_iam_user.ci_account.name
}

resource "aws_iam_user" "ci_account" {
  name = "${local.project}-ci-account"
  path = "/system/"
}

resource "aws_iam_access_key" "trade_tariff_bot_account" {
  user = aws_iam_user.trade_tariff_bot_account.name
}

resource "aws_iam_user" "trade_tariff_bot_account" {
  name = "${local.project}-bot"
  path = "/system/"
}

resource "aws_iam_access_key" "dit_database_backups_account" {
  user = aws_iam_user.dit_database_backups_account.name
}

resource "aws_iam_user" "dit_database_backups_account" {
  name = "${local.project}-dit-database-backups"
  path = "/customer/"
}

resource "aws_iam_role" "ecr_access" {
  name = "ci-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr-policy"
  description = "ECR policy for managing project deployment ECR images"

  policy = data.aws_iam_policy_document.ecr.json
}

data "aws_iam_policy_document" "ecr" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImageScanFindings",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:InitiateLayerUpload",
      "ecr:ListImages",
      "ecr:ListTagsForResource",
      "ecr:PutImage",
      "ecr:PutImageScanningConfiguration",
      "ecr:PutImageTagMutability",
      "ecr:PutLifecyclePolicy",
      "ecr:StartImageScan",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:TagResource",
      "ecr:UploadLayerPart",
    ]
    resources = [
      "arn:aws:ecr:eu-west-2:777015734912:repository/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:DescribeRegistry",
      "ecr:GetAuthorizationToken",
      "ecr:GetRegistryPolicy",
      "ecr:PutRegistryPolicy",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "es_policy" {
  name        = "es-policy"
  description = "ES policy for custom package lifecycle management"

  policy = data.aws_iam_policy_document.es.json
}

data "aws_iam_policy_document" "es" {
  statement {
    actions = [
      "es:DescribePackages",
      "es:UpdatePackage",
      "es:ListPackagesForDomain",
    ]
    resources = ["*"]
  }

  statement {
    actions = ["es:AssociatePackage"]
    resources = [
      data.aws_opensearch_domain.development.arn,
      data.aws_opensearch_domain.staging.arn,
      data.aws_opensearch_domain.production.arn
    ]
  }
}

resource "aws_iam_policy" "ses_policy" {
  name        = "ses-policy"
  description = "SES policy for users to send mail using SES"

  policy = data.aws_iam_policy_document.ses.json
}

data "aws_iam_policy_document" "ses" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy_attachment" "ci_ses" {
  user       = aws_iam_user.ci_account.name
  policy_arn = aws_iam_policy.ses_policy.arn
}

resource "aws_iam_user_policy_attachment" "ci_ecr" {
  user       = aws_iam_user.ci_account.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_iam_user_policy_attachment" "ci_es" {
  user       = aws_iam_user.ci_account.name
  policy_arn = aws_iam_policy.es_policy.arn
}
