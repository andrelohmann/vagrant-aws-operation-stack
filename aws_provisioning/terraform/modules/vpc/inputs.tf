/**
 * Input Variables
 */
variable "cidr" {
  description = "The CIDR block for the VPC"
}

variable "name" {
  description = "Name tag"
}

variable "environment" {
  description = "Environment tag"
}

variable "prefix" {
  description = "Operations Stack Prefix"
}

variable "dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  default = true
}

variable "dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default = false
}

variable "availability_zones" {
  type = list
  description = "List of availability zones"
}

variable "public_subnets" {
  type = map
  description = "Map of subnets with AZ as key"
  default = {}
}

variable "private_subnets" {
  type = map
  description = "Map of subnets with AZ as key"
}
