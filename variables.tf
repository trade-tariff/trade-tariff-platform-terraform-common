variable "notification_email" {
  type        = string
  description = "Email address to send worker reports from."
  default     = "trade-tariff-support@enginegroup.com"
}

variable "docker_repositories" {
  type        = list(string)
  description = "List of repositories to create."
  default = [
    "tariff-backend",
    "tariff-frontend",
    "tariff-dutycalculator",
    "tariff-admin",
    "tariff-search-query-parser",
    "signon",
  ]
}

variable "google_site_verification" {
  type        = string
  description = "Google site verification TXT record value."
}

variable "trade_tariff_reporting" {
  type    = string
  default = "reporting.trade-tariff.service.gov.uk"
}

variable "waf_name" {
  type    = string
  default = "tariff-waf-production"
}

variable "s3_origin_id" {
  type    = string
  default = "trade_tariff_reporting_origin"
}
