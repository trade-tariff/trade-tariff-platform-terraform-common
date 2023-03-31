resource "aws_ses_email_identity" "notify_email" {
  email = var.notification_email
}

resource "aws_ses_domain_identity" "tariff_domain" {
  domain = local.base_url
}

resource "aws_ses_domain_identity_verification" "tariff_domain_verification" {
  domain     = aws_ses_domain_identity.tariff_domain.id
  depends_on = [aws_route53_record.tariff_domain_verification_record]
}

resource "aws_route53_record" "tariff_domain_verification_record" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "_amazonses.${aws_ses_domain_identity.tariff_domain.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.tariff_domain.verification_token]
}

resource "aws_iam_user_policy" "ses_policy" {
  name   = "ses-send-emails"
  policy = data.aws_iam_policy_document.ses_policy.json
  user   = aws_iam_user.service_account.name
}

data "aws_iam_policy_document" "ses_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    resources = "*"
  }
}
