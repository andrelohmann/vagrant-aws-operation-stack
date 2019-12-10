/**
 * This File defines all necessary variables for the non-ephemeral instance
 */

variable "name" {
  type = string
  description = "Name of the instance"
}

variable "prefix" {
  type = string
  description = "Prefix"
}

variable "additional_tags" {
  type = map
  description = "Additional tags of the instance"
  default = {}
}

variable "key_name" {
  type = string
  description = "Key-Pair name that needs to be deployed"
}

variable "ami_id" {
  type = string
  description = "AMI ID of the instance"
}

variable "instance_type" {
  type = string
  description = "Instance Type"
}

variable "vpc_id" {
  type = string
  description = "VPC ID, the insntace is attached to"
}

variable "availability_zone" {
  type = string
  description = "Availability Zone, the insntace is running in"
}

variable "subnet_id" {
  type = string
  description = "Subnet, the insntace is running in"
}

variable "security_group_ids" {
  type = list
  description = "Securtygroup IDs, the instance is attached to"
}

variable "private_ip" {
  type = string
  description = "Provate IP of the instance"
}

variable "eip_id" {
  type = string
  description = "ID of the instances Elastic IP"
}

variable "eip_ip" {
  type = string
  description = "The instances Elastic IP"
}

variable "volume_size" {
  type = string
  default = "100"
  description = "Volume size of the instances root volume"
}

variable "volume_type" {
  type = string
  default = "gp2"
  description = "Volume type of the instances root volume"
}

variable "user_groups" {
  type = string
  description = "Comma separated list of user groups"
}

variable "pausable" {
  type = string
  default = "False"
  description = "allow to pause the instance with awspause; True or False"
}

variable "public_zone_id" {
  type = string
  description = "The public DNS Zone ID"
}

variable "private_zone_id" {
  type = string
  description = "The private DNS Zone ID"
}

variable "reverse_zone_id" {
  type = string
  description = "The Reverse DNS Zone ID"
}

variable "zone_domain" {
  type = string
  description = "The main Zone Domain"
}
