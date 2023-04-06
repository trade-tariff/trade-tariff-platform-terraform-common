locals {
  project    = "trade-tariff"
  base_url   = "${local.project}.service.gov.uk"
  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Project = local.project
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
