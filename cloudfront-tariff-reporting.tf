data "aws_wafv2_web_acl" "this" {
  name     = var.waf_name
  scope    = "CLOUDFRONT"
  provider = aws.east
}

resource "aws_cloudfront_origin_access_identity" "trade_tariff_reporting_identity" {
  comment = "trade_tariff_reporting"
}

resource "aws_cloudfront_distribution" "s3_distribution_trade_tariff_reporting" {
  origin {
    domain_name = aws_s3_bucket.this["reporting"].bucket_regional_domain_name
    origin_id   = var.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.trade_tariff_reporting_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Trade Tariff Reporting CDN"
  aliases         = ["reporting.trade-tariff.service.gov.uk"]
  price_class     = "PriceClass_100"
  web_acl_id      = data.aws_wafv2_web_acl.this.arn


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn      = module.reporting_certificate.aws_acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [
    module.reporting_certificate.aws_acm_certificate_arn
  ]

  lifecycle {
    ignore_changes = [origin]
  }
}

module "reporting_certificate" {
  source          = "git@github.com:trade-tariff/trade-tariff-platform-terraform-modules.git//aws/acm?ref=aws/cloudfront-v1.0.1"
  domain_name     = "reporting.${local.base_url}"
  route53_zone_id = data.aws_route53_zone.selected.id
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.this["reporting"].id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.this["reporting"].arn}/*",
      aws_s3_bucket.this["reporting"].arn
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.trade_tariff_reporting_identity.iam_arn
      ]
    }
  }
}
