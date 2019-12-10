# Terraform SES SMTP Module

This module creates a SES Resource, to offer an outgoing email server for computational emails.

The following variables need to be defined, when using this module:

        module "ses_smtp" {
          source                      = "./modules/ses_smtp"
          dmarc_rua                   = "${var.dmarc_rua}"
          domain_name                 = "${var.operations_domain}"
          mail_from_domain            = "email.${var.operations_domain}"
          route53_zone_id             = "${var.public_zone_id}"
        }

The Module then outputs:

        ses_identity_arn # SES Identity ARN
