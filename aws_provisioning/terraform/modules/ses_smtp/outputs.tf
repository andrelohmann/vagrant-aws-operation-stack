output "ses_identity_arn" {
  description = "SES identity ARN."
  value       = aws_ses_domain_identity.main.arn
}

output "smtp_key" {
  value = "${aws_iam_access_key.smtp.id}"
}

output "smtp_secret" {
  value = "${aws_iam_access_key.smtp.ses_smtp_password}"
}

output "smtp_plain_secret" {
  value = "${aws_iam_access_key.smtp.secret}"
}

output "smtp_host" {
  value = "email-smtp.${data.aws_region.current.name}.amazonaws.com"
}
