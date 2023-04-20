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

  buckets = {
    reporting = "${local.project}-reporting"
    backups   = "${local.project}-database-backups"
  }

  bucket_permissions = {
    read_write = [
      "s3:AbortMultipartUpload",
      "s3:AbortUpload",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObjectVersionTagging",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectTorrent",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionTorrent",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:ListBucketVersions",
      "s3:ListMultipartUploadParts",
      "s3:ListObjectsV2",
      "s3:ListUploadParts",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging",
      "s3:RestoreObject"
    ]
    read = [
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
  }
}

data "aws_kms_key" "s3_kms_encryption_key" {
  key_id = "alias/aws/s3"
}

resource "aws_s3_bucket" "this" {
  for_each = local.buckets
  bucket   = each.value
  tags     = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = local.buckets
  bucket   = each.value
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = data.aws_kms_key.s3_kms_encryption_key.id
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_acl" "this" {
  for_each = local.buckets
  bucket   = each.value
  acl      = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = local.buckets
  bucket   = each.value

  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
}

resource "aws_iam_policy" "database_backups_read" {
  name        = "database-backups-read"
  description = "Enables reading database backups"
  policy      = data.aws_iam_policy_document.s3_database_backups_read_policy.json
}

resource "aws_iam_policy" "this" {
  for_each    = local.buckets
  name        = "${each.key}-read-write"
  description = "Provides read and write access to the ${each.key} bucket."
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = local.bucket_permissions.read_write
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.this[each.key].arn,
          "${aws_s3_bucket.this[each.key].arn}/*",
        ]
      }
    ]
  })
}

data "aws_iam_policy_document" "s3_database_backups_read_policy" {
  statement {
    effect  = "Allow"
    actions = local.bucket_permissions.read
    resources = [
      aws_s3_bucket.this["backups"].arn,
      "${aws_s3_bucket.this["backups"].arn}/*",
    ]
  }
}

resource "aws_iam_user_policy_attachment" "ci_account_s3_attachments" {
  for_each   = toset(local.ci_account_s3_policies)
  user       = aws_iam_user.ci_account.name
  policy_arn = "arn:aws:iam::${local.account_id}:policy/${each.value}-read-write"
}

resource "aws_iam_user_policy_attachment" "service_account_s3_attachments" {
  for_each   = toset(local.service_account_s3_policies)
  user       = aws_iam_user.service_account.name
  policy_arn = "arn:aws:iam::${local.account_id}:policy/${each.value}-read-write"
}

resource "aws_iam_user_policy_attachment" "dit_database_backups_account_s3_attachments" {
  user       = aws_iam_user.dit_database_backups_account.name
  policy_arn = aws_iam_policy.database_backups_read.arn
}
