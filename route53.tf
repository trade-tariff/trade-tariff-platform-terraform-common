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
