locals {
  project  = "trade-tariff"
  base_url = "${local.project}.service.gov.uk"

  tags = {
    Project     = local.project
    Environment = var.environment
  }
}

data "aws_caller_identity" "current" {}

data "aws_opensearch_domain" "development" {
  domain_name = "tariff-search-development"
}

data "aws_opensearch_domain" "staging" {
  domain_name = "tariff-search-staging"
}

data "aws_opensearch_domain" "production" {
  domain_name = "tariff-search-production"
}
