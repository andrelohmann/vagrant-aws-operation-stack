/**
 * smtp credentials
 */
output "smtp_credentials" {
  value = {
    smtp_key                    = "${module.ses_smtp.smtp_key}"
    smtp_plain_secret           = "${module.ses_smtp.smtp_plain_secret}"
    smtp_secret                 = "${module.ses_smtp.smtp_secret}"
    smtp_host                   = "${module.ses_smtp.smtp_host}"
  }
}

# Reserved EIP
output "eip" {
  value = {
    server = "operations"
    id = "${aws_eip.operations.id}"
    ip = "${aws_eip.operations.public_ip}"
  }
}
