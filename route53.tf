data "aws_route53_zone" "selected" {
  name         = "${local.base_url}."
  private_zone = false
}

resource "aws_route53_record" "google_validation" {
  zone_id = data.aws_route53_zone.selected.id
  name    = local.base_url
  type    = "TXT"
  ttl     = "300"
  records = [var.google_site_verification]
}

/* dns record for trade tariff reporting */
resource "aws_route53_record" "trade_tariff_reporting" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.trade_tariff_reporting
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.s3_distribution_trade_tariff_reporting.domain_name]
}