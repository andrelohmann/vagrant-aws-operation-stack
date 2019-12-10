/**
 * This File defines all necessary variables for Terraform Step
 */

variable "region" {
  type = string
  description = "The Aws region"
}

variable "availability_zones" {
  type = list
  description = "The AWS availability zones"
}

variable "ami_id" {
  type = string
  description = "The AWS AMI ID to use for the instance"
}

variable "public_zone_id" {
  type = string
  description = "The public zone id, if domain was registered with AWS"
}

variable "operations_domain" {
  type = string
  description = "The subdomain, used for the operations stack"
}

variable "prefix" {
  type = string
  description = "The prefix, set for resources, to identify multiple Operations Stack Deployments"
}

variable "additional_tags" {
  type = map
  description = "Additional instance tags"
  default = {}
}

variable "dmarc_rua" {
  type = string
  description = "The DMARC rua email address"
}

variable "email_identities" {
  type = list
  description = "List of SES Email Address Identities"
}
