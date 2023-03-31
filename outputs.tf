output "service_iam_id" {
  value = aws_iam_access_key.service_account.id
}

output "service_secret" {
  value     = aws_iam_access_key.service_account.secret
  sensitive = true
}

output "ci_iam_id" {
  value = aws_iam_access_key.service_account.id
}

output "ci_secret" {
  value     = aws_iam_access_key.service_account.secret
  sensitive = true
}
