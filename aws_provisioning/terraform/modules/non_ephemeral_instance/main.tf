/**
 * Define loca variables
 */
locals {
  instance_tags = {
    "Name"                            = "${var.prefix == "" ? "" : format("%s-", var.prefix) }${var.name}.${var.zone_domain}"
    "VPCID"                           = var.vpc_id
    "UserGroup"                       = var.user_groups
    "Ephemeral"                       = "False"
    "Pausable"                        = var.pausable
    "Backup"                          = "Backup" # github.com/kgorskowski/ebs_bckup needs a Tag Value of "Backup"
  }
}

/**
 * Create the non-ephemeral Instance
 */
resource "aws_instance" "i" {
  ami                               = var.ami_id
  instance_type                     = var.instance_type

  availability_zone                 = var.availability_zone
  subnet_id                         = var.subnet_id
  vpc_security_group_ids            = var.security_group_ids

  private_ip                        = var.private_ip

  key_name                          = var.key_name

  user_data                         = file("${path.module}/user_data.sh")

  # Protect the instance from being deleted
  disable_api_termination           = true

  root_block_device {
    # Protect the instance from being deleted
    delete_on_termination           = false
    volume_size                     = var.volume_size
    volume_type                     = var.volume_type
  }

  tags = merge(local.instance_tags, var.additional_tags)

}

/**
 * Associate the reserved EIP
 */
resource "aws_eip_association" "i_eip" {
  instance_id   = aws_instance.i.id
  allocation_id = var.eip_id
}

/**
 * Add the public DNS record
 */
resource "aws_route53_record" "i_public" {
  zone_id = var.public_zone_id
  name    = "${var.name}.${var.zone_domain}"
  type    = "A"
  ttl     = "300"
  records = [var.eip_ip]
}

/**
 * Add the private DNS record
 */
resource "aws_route53_record" "i_private" {
  zone_id = var.private_zone_id
  name    = "${var.name}.${var.zone_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.i.private_ip]
}

/**
 * Add the reverse record
 */
resource "aws_route53_record" "arpa" {
  zone_id = var.reverse_zone_id
  name    = "${element(split(".", aws_instance.i.private_ip),3)}.${element(split(".", aws_instance.i.private_ip),2)}.${element(split(".", aws_instance.i.private_ip),1)}.${element(split(".", aws_instance.i.private_ip),0)}.in-addr.arpa"
  type    = "PTR"
  ttl     = "300"
  records = ["${var.name}.${var.zone_domain}"]
}
