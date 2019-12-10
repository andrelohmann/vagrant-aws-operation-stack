/**
 * Create deployer key-pair
 *
 * Read the public key from /home/vagrant/.ssh/id_rsa.pub
 */
resource "aws_key_pair" "deployer" {
  key_name   = "${var.prefix == "" ? "" : format("%s-", var.prefix) }deployer-key"
  public_key = file("/home/vagrant/.ssh/id_rsa.pub")
 }

/**
 * Create route53 private domain zone for the operations (sub)domain
 */
resource "aws_route53_zone" "private_zone" {
  name   = var.operations_domain
  vpc {
    vpc_id = module.operations-vpc.id
  }
}

/**
 * Reverse DNS Zone
 */
resource "aws_route53_zone" "reverse_zone" {
  name   = "10.in-addr.arpa"
  vpc {
    vpc_id = module.operations-vpc.id
  }
}

/**
 * DHCP Options operations-vpc
 */
resource "aws_vpc_dhcp_options" "operations-vpc" {
  domain_name = var.operations_domain
  domain_name_servers  = ["10.10.0.2"]
  #ntp_servers          = ["127.0.0.1"]

  tags = {
    Name = var.operations_domain
  }
}

resource "aws_vpc_dhcp_options_association" "operations-vpc" {
  vpc_id          = module.operations-vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.operations-vpc.id
}

/**
 * Create Operations VPC
 *
 * Run the Operations Instance separated from all other VPCs, as it is non-ephemeral
 */
module "operations-vpc" {
  source                = "./modules/vpc"
  cidr                  = "10.10.0.0/16"
  name                  = "operations-vpc"
  environment           = "operations"
  prefix                = var.prefix
  availability_zones    = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets        = {
    "eu-central-1a" = "10.10.0.0/20"
    "eu-central-1b" = "10.10.16.0/20"
    "eu-central-1c" = "10.10.32.0/20"
  }
  private_subnets       = {
    "eu-central-1a" = "10.10.48.0/20"
    "eu-central-1b" = "10.10.64.0/20"
    "eu-central-1c" = "10.10.80.0/20"
  }
  dns_hostnames         = true
}

/**
 * Create ElasticIP for the operations Instance
 */
resource "aws_eip" "operations" {
  vpc      = true
  tags = {
    Name                                  = "operations"
  }
}

/**
 * EBS Backup
 * Backup all tagged instances
 */
module "ebs_bckup" {
  source = "github.com/andrelohmann/ebs_bckup"
  EC2_INSTANCE_TAG = "Backup"
  RETENTION_DAYS   = 3
  unique_name      = "v1"
  stack_prefix     = "${var.prefix == "" ? "" : format("%s-", var.prefix) }ebs_snapshot"
  cron_expression  = "0 3 * * ? *" # Snapshots are done every day at 03:00 in the morning
  regions          = ["eu-central-1"]
}

/**
 * AWS Pause
 * Automatically stop all pausable instances
 */
module "aws_pause" {
  source            = "github.com/andrelohmann/aws_pause_terraform"
  unique_name      = "v1"
  stack_prefix     = "${var.prefix == "" ? "" : format("%s-", var.prefix) }aws_pause"
  cron_expression  = "0 22 * * ? *" # Instances are stopped automatically each night at 22:00
  regions          = ["eu-central-1"]
}

/**
 * Create SSH SecurityGroup
 */
module "ssh_sg" {
  source                      = "./modules/public_port_sg"
  name                        = "${var.prefix == "" ? "" : format("%s-", var.prefix) }ssh"
  port                        = "22"
  vpc_id                      = module.operations-vpc.id
}

/**
 * Create HTTP SecurityGroup
 */
module "http_sg" {
  source                      = "./modules/public_port_sg"
  name                        = "${var.prefix == "" ? "" : format("%s-", var.prefix) }http"
  port                        = "80"
  vpc_id                      = module.operations-vpc.id
}

/**
 * Create HTTPS SecurityGroup
 */
module "https_sg" {
  source                      = "./modules/public_port_sg"
  name                        = "${var.prefix == "" ? "" : format("%s-", var.prefix) }https"
  port                        = "443"
  vpc_id                      = module.operations-vpc.id
}

/**
 * Create operations instance
 *
 * Including Gitlab, Gitlab runner, jenkins
 *
 */
module "operations" {
  source                      = "./modules/non_ephemeral_instance"
  name                        = "operations"
  prefix                      = var.prefix
  additional_tags             = var.additional_tags
  key_name                    = "${var.prefix == "" ? "" : format("%s-", var.prefix) }deployer-key"
  ami_id                      = var.ami_id
  instance_type               = "c5.2xlarge"
  vpc_id                      = module.operations-vpc.id
  availability_zone           = var.availability_zones[0]
  subnet_id                   = module.operations-vpc.public_subnets[0]
  security_group_ids          = [module.operations-vpc.egress_sg_id, module.ssh_sg.id, module.http_sg.id, module.https_sg.id]
  private_ip                  = "10.10.0.11"
  eip_id                      = aws_eip.operations.id
  eip_ip                      = aws_eip.operations.public_ip
  volume_size                 = "300"
  volume_type                 = "gp2"
  user_groups                 = "operations"
  pausable                    = "True"
  public_zone_id              = var.public_zone_id
  private_zone_id             = aws_route53_zone.private_zone.zone_id
  reverse_zone_id             = aws_route53_zone.reverse_zone.zone_id
  zone_domain                 = var.operations_domain
}

/**
 * Add the public git DNS record
 */
resource "aws_route53_record" "git_public" {
  zone_id = var.public_zone_id
  name    = "git.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.operations.public_ip}"]
}

/**
 * Add the private git DNS record
 */
resource "aws_route53_record" "git_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "git.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = ["10.10.0.11"]
}

/**
 * Add the public docker DNS record
 */
resource "aws_route53_record" "docker_public" {
  zone_id = var.public_zone_id
  name    = "docker.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.operations.public_ip]
}

/**
 * Add the private docker DNS record
 */
resource "aws_route53_record" "docker_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "docker.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = ["10.10.0.11"]
}

/**
 * Add the public chat DNS record
 */
resource "aws_route53_record" "chat_public" {
  zone_id = var.public_zone_id
  name    = "chat.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.operations.public_ip]
}

/**
 * Add the private chat DNS record
 */
resource "aws_route53_record" "chat_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "chat.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = ["10.10.0.11"]
}

/**
 * Add the public jenkins DNS record
 */
resource "aws_route53_record" "jenkins_public" {
  zone_id = var.public_zone_id
  name    = "jenkins.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.operations.public_ip]
}

/**
 * Add the private jenkins DNS record
 */
resource "aws_route53_record" "jenkins_private" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "jenkins.${var.operations_domain}"
  type    = "A"
  ttl     = "300"
  records = ["10.10.0.11"]
}

/**
 * SES - Simple Mail Services
 */
module "ses_smtp" {
  source                      = "./modules/ses_smtp"
  dmarc_rua                   = var.dmarc_rua
  domain_name                 = var.operations_domain
  mail_from_domain            = "email.${var.operations_domain}"
  route53_zone_id             = var.public_zone_id
  email_identities            = var.email_identities
}
