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
    origin_id   = aws_cloudfront_origin_access_identity.trade_tariff_reporting_identity.cloudfront_access_identity_path

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.trade_tariff_reporting_identity.id
    }
  }

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Trade Tariff Reporting CDN"
  aliases         = ["reporting.trade-tariff.service.gov.uk"]
  price_class     = "PriceClass_100"
  web_acl_id      = data.aws_wafv2_web_acl.this.id


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
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  lifecycle {
    ignore_changes = [origin]
  }

}

