variable "environments" {
  type        = list(any)
  description = "List of environment name keys to use in environment interpolation."
  default     = ["development", "staging", "production"]
}

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
