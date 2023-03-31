locals {
  ci_account_s3_policies = [
    "reporting",
    "search-configuration",
    "opensearch-package",
    "database-backups",
  ]
  service_account_s3_policies = [
    "search-configuration",
    "opensearch-package",
  ]
}

data "aws_kms_key" "s3_kms_encryption_key" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "reporting" {
  bucket = "${local.project}-reporting"
  acl    = "private"

  tags = {
    Project = local.project
  }
}

resource "aws_s3_bucket" "terragrunt_state" {
  bucket = "${local.project}-terragrunt-state"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false
      apply_server_side_encryption_by_default {
        kms_master_key_id = data.aws_kms_key.s3_kms_encryption_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
  tags = {
    Project = local.project
  }
}

resource "aws_s3_bucket" "database_backups" {
  bucket = "${local.project}-database-backups"
  acl    = "private"

  tags = {
    Project = local.project
  }
}

resource "aws_s3_bucket" "opensearch_packages" {
  count = length(var.environments)

  bucket = "${local.project}-opensearch-packages-${var.environments[count.index]}"
  acl    = "private"

  tags = {
    Project     = local.project
    Environment = element(var.environments, count.index)
  }
}

resource "aws_s3_bucket" "search_configuration" {
  count = length(var.environments)

  bucket = "${local.project}-search-configuration-${var.environments[count.index]}"
  acl    = "private"

  tags = {
    Project     = local.project
    Environment = element(var.environments, count.index)
  }
}

resource "aws_s3_bucket_public_access_block" "reporting" {
  bucket = aws_s3_bucket.reporting.id

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_public_access_block" "database_backups" {
  bucket = aws_s3_bucket.database_backups.id

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_public_access_block" "opensearch_packages" {
  count  = length(aws_s3_bucket.opensearch_packages)
  bucket = aws_s3_bucket.opensearch_packages[count.index].id

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_public_access_block" "search_configuration" {
  count  = length(aws_s3_bucket.search_configuration)
  bucket = aws_s3_bucket.search_configuration[count.index].id

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

resource "aws_iam_policy" "terragrunt_state" {
  name        = "terragrunt-state-read-write"
  description = "Provides read and write access to the global terragrunt-state bucket. This is where all of our terraform state files live."
  policy      = data.aws_iam_policy_document.s3_terragrunt_state_policy.json
}

resource "aws_iam_policy" "reporting" {
  name        = "reporting-read-write"
  description = "Provides read and write access to the generic reporting bucket."
  policy      = data.aws_iam_policy_document.s3_reporting_policy.json
}

resource "aws_iam_policy" "database_backups_read" {
  name        = "database-backups-read"
  description = "Enables reading database backups"
  policy      = data.aws_iam_policy_document.s3_database_backups_read_policy.json
}

resource "aws_iam_policy" "database_backups_read_write" {
  name        = "database-backups-read-write"
  description = "Enables reading and writing database backups"
  policy      = data.aws_iam_policy_document.s3_database_backups_read_write_policy.json
}

resource "aws_iam_policy" "opensearch_package" {
  name        = "opensearch-package-read-write"
  description = "Provides read and write access to manage opensearch synonym packages"
  policy      = data.aws_iam_policy_document.s3_search_package_policy.json
}

resource "aws_iam_policy" "search_configuration" {
  name        = "search-configuration-read-write"
  description = "Provides read and write access to manage search configuration fixtures - especially those used for search query parsing/spelling corrections, etc."
  policy      = data.aws_iam_policy_document.s3_search_configuration_policy.json
}

data "aws_iam_policy_document" "s3_terragrunt_state_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${local.project}-terragrunt-state",
      "arn:aws:s3:::${local.project}-terragrunt-state/*",
    ]
  }

  statement {
    actions = [
      "s3:AbortUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListUploadParts",
      "s3:ListObjectsV2",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
      "s3:RestoreObject",
    ]

    resources = [
      "arn:aws:s3:::${local.project}-terragrunt-state",
      "arn:aws:s3:::${local.project}-terragrunt-state/*",
    ]
  }
}

data "aws_iam_policy_document" "s3_reporting_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${local.project}-reporting",
      "arn:aws:s3:::${local.project}-reporting/*",
    ]
  }

  statement {
    actions = [
      "s3:AbortUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListUploadParts",
      "s3:ListObjectsV2",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
      "s3:RestoreObject",
    ]

    resources = [
      "arn:aws:s3:::${local.project}-reporting",
      "arn:aws:s3:::${local.project}-reporting/*",
    ]
  }
}

data "aws_iam_policy_document" "s3_database_backups_read_write_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${local.project}-database-backups",
      "arn:aws:s3:::${local.project}-database-backups/*",
    ]
  }

  statement {
    actions = [
      "s3:AbortUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListUploadParts",
      "s3:ListObjectsV2",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
      "s3:RestoreObject",
    ]

    resources = [
      "arn:aws:s3:::${local.project}-database-backups",
      "arn:aws:s3:::${local.project}-database-backups/*",
    ]
  }
}

data "aws_iam_policy_document" "s3_database_backups_read_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${local.project}-database-backups",
      "arn:aws:s3:::${local.project}-database-backups/*",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListUploadParts",
      "s3:ListObjectsV2",
    ]

    resources = [
      "arn:aws:s3:::${local.project}-database-backups",
      "arn:aws:s3:::${local.project}-database-backups/*",
    ]
  }
}

data "aws_iam_policy_document" "s3_search_package_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${local.project}-opensearch-packages-*",
      "arn:aws:s3:::${local.project}-opensearch-packages-*/*",
    ]
  }

  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
      "s3:RestoreObject",
    ]

    resources = [
      "arn:aws:s3:::${local.project}-opensearch-packages-*",
      "arn:aws:s3:::${local.project}-opensearch-packages-*/*",
    ]
  }
}

data "aws_iam_policy_document" "s3_search_configuration_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
    ]
    resources = [
      "arn:aws:s3:::${local.project}-search-configuration-*",
      "arn:aws:s3:::${local.project}-search-configuration-*/*",
    ]
  }

  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
      "s3:RestoreObject",
    ]

    resources = [
      "arn:aws:s3:::${local.project}-search-configuration-*",
      "arn:aws:s3:::${local.project}-search-configuration-*/*",
    ]
  }
}

resource "aws_iam_user_policy_attachment" "ci_account_s3_attachments" {
  count      = length(local.ci_account_s3_policies)
  user       = aws_iam_user.ci_account.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.ci_account_s3_policies[count.index]}-read-write"
}

resource "aws_iam_user_policy_attachment" "service_account_s3_attachments" {
  count      = length(local.service_account_s3_policies)
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${local.service_account_s3_policies[count.index]}-read-write"
}

resource "aws_iam_user_policy_attachment" "dit_database_backups_account_s3_attachments" {
  user       = aws_iam_user.dit_database_backups_account.name
  policy_arn = aws_iam_policy.database_backups_read.arn
}

resource "aws_iam_user_policy_attachment" "trade_tariff_bot_terragrunt_state_s3_attachment" {
  user       = aws_iam_user.trade_tariff_bot_account.name
  policy_arn = aws_iam_policy.terragrunt_state.arn
}
