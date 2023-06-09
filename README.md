# trade-tariff-platform-terraform-common

Repository to store the Terraform for common AWS infrastructure.

## Making changes

Any changes to the infrastructure must go through the pull request process.
Terraform commands are run in CI automatically when commits are pushed to a
branch, and the plan output is posted as a comment to an opened pull request.

Once the changes are merged into main, they will be applied automatically.

## Running locally

Much of the configuration can be tested via the use of the included
[pre-commit](https://pre-commit.com/) hooks. It is recommended to run these
as it will run `terraform fmt` and `validate` steps against your changes,
catching any errors.

To avoid having to input variables manually when running commands, consider
creating `.tfvars` files for this purpose. They are `gitignore`d and should
not be committed to this repository.

If you need to run plans/applies locally, you will need **AWS credentials**
configured before you can do so.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.61.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.61.0 |
| <a name="provider_aws.east"></a> [aws.east](#provider\_aws.east) | 4.61.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_reporting_certificate"></a> [reporting\_certificate](#module\_reporting\_certificate) | git@github.com:trade-tariff/trade-tariff-platform-terraform-modules.git//aws/acm | aws/cloudfront-v1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution_trade_tariff_reporting](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.trade_tariff_reporting_identity](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_ecr_lifecycle_policy.rule](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.docker](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/ecr_repository) | resource |
| [aws_iam_access_key.ci_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.dit_database_backups_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.service_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.trade_tariff_bot_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.database_backups_read](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecr_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.es_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ses_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.ecr_access](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_role) | resource |
| [aws_iam_user.ci_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user) | resource |
| [aws_iam_user.dit_database_backups_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user) | resource |
| [aws_iam_user.service_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user) | resource |
| [aws_iam_user.trade_tariff_bot_account](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.ses_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy) | resource |
| [aws_iam_user_policy_attachment.ci_account_s3_attachments](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.ci_ecr](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.ci_es](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.ci_ses](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.dit_database_backups_account_s3_attachments](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.service_account_s3_attachments](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/iam_user_policy_attachment) | resource |
| [aws_route53_record.google_validation](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/route53_record) | resource |
| [aws_route53_record.tariff_domain_verification_record](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/route53_record) | resource |
| [aws_route53_record.trade_tariff_reporting](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/route53_record) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_policy.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_ses_domain_identity.tariff_domain](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity_verification.tariff_domain_verification](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/ses_domain_identity_verification) | resource |
| [aws_ses_email_identity.notify_email](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/resources/ses_email_identity) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecr](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.es](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.s3_database_backups_read_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ses](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ses_policy](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/iam_policy_document) | data source |
| [aws_opensearch_domain.development](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/opensearch_domain) | data source |
| [aws_opensearch_domain.production](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/opensearch_domain) | data source |
| [aws_opensearch_domain.staging](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/opensearch_domain) | data source |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/route53_zone) | data source |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/4.61.0/docs/data-sources/wafv2_web_acl) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_docker_repositories"></a> [docker\_repositories](#input\_docker\_repositories) | List of repositories to create. | `list(string)` | <pre>[<br>  "tariff-backend",<br>  "tariff-frontend",<br>  "tariff-dutycalculator",<br>  "tariff-admin",<br>  "tariff-search-query-parser",<br>  "signon"<br>]</pre> | no |
| <a name="input_google_site_verification"></a> [google\_site\_verification](#input\_google\_site\_verification) | Google site verification TXT record value. | `string` | n/a | yes |
| <a name="input_notification_email"></a> [notification\_email](#input\_notification\_email) | Email address to send worker reports from. | `string` | `"trade-tariff-support@enginegroup.com"` | no |
| <a name="input_s3_origin_id"></a> [s3\_origin\_id](#input\_s3\_origin\_id) | n/a | `string` | `"trade_tariff_reporting_origin"` | no |
| <a name="input_trade_tariff_reporting"></a> [trade\_tariff\_reporting](#input\_trade\_tariff\_reporting) | n/a | `string` | `"reporting.trade-tariff.service.gov.uk"` | no |
| <a name="input_waf_name"></a> [waf\_name](#input\_waf\_name) | n/a | `string` | `"tariff-waf-production"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ci_iam_id"></a> [ci\_iam\_id](#output\_ci\_iam\_id) | n/a |
| <a name="output_ci_secret"></a> [ci\_secret](#output\_ci\_secret) | n/a |
| <a name="output_service_iam_id"></a> [service\_iam\_id](#output\_service\_iam\_id) | n/a |
| <a name="output_service_secret"></a> [service\_secret](#output\_service\_secret) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
