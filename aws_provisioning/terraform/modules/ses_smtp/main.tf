locals {
  # some ses resources don't allow for the terminating '.' in the domain name
  # so use a replace function to strip it out
  stripped_domain_name = replace(var.domain_name, "/[.]$/", "")

  stripped_mail_from_domain = replace(var.mail_from_domain, "/[.]$/", "")
  dash_domain               = replace(var.domain_name, ".", "-")
}

#
# SES Domain Verification
#

resource "aws_ses_domain_identity" "main" {
  domain = local.stripped_domain_name
}

resource "aws_ses_domain_identity_verification" "main" {
  domain = aws_ses_domain_identity.main.id

  depends_on = [aws_route53_record.ses_verification]
}

resource "aws_route53_record" "ses_verification" {
  zone_id = var.route53_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.main.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.main.verification_token]
}

#
# SES DKIM Verification
#

resource "aws_ses_domain_dkim" "main" {
  domain = aws_ses_domain_identity.main.domain
}

resource "aws_route53_record" "dkim" {
  count   = 3
  zone_id = var.route53_zone_id
  name = format(
    "%s._domainkey.%s",
    element(aws_ses_domain_dkim.main.dkim_tokens, count.index),
    var.domain_name,
  )
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.main.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

#
# SES MAIL FROM Domain
#

resource "aws_ses_domain_mail_from" "main" {
  domain           = aws_ses_domain_identity.main.domain
  mail_from_domain = local.stripped_mail_from_domain
}

# SPF validaton record
resource "aws_route53_record" "spf_mail_from" {
  zone_id = var.route53_zone_id
  name    = aws_ses_domain_mail_from.main.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

resource "aws_route53_record" "spf_domain" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com -all"]
}

# Sending MX Record
data "aws_region" "current" {
}

resource "aws_route53_record" "mx_send_mail_from" {
  zone_id = var.route53_zone_id
  name    = aws_ses_domain_mail_from.main.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

#
# DMARC TXT Record
#
resource "aws_route53_record" "txt_dmarc" {
  zone_id = var.route53_zone_id
  name    = "_dmarc.${var.domain_name}"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1; p=none; rua=mailto:${var.dmarc_rua};"]
}

#
# SMTP IAM User
#
resource "aws_iam_access_key" "smtp" {
  user    = aws_iam_user.smtp.name
}

resource "aws_iam_user" "smtp" {
  name = "smtp-${local.dash_domain}"
  path = "/smtp-${local.dash_domain}/"
}

resource "aws_iam_user_policy" "smtp" {
  name = "smtp-${local.dash_domain}"
  user = aws_iam_user.smtp.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ses:SendRawEmail",
            "Resource": "*"
        }
    ]
}
EOF
}

#
# SES Email Identities
#
resource "aws_ses_email_identity" "example" {
  count = length(var.email_identities)
  email = element(var.email_identities, count.index)
}
