/**
 * Input Variables
 */
variable "connection_name" {
  type = string
  description = "The Peering Connection name"
}
variable "account_id" {
  type = string
  description = "The Aws account ID"
}

variable "requester_id" {
  type = string
  description = "The requesting VPC ID"
}

variable "accepter_id" {
  type = string
  description = "The accepting VPC ID"
}

variable "requester_cidr_block" {
  type = string
  description = "The CIDR block of the requesting VPC"
}

variable "accepter_cidr_block" {
  type = string
  description = "The CIDR block of the accepting VPC"
}

variable "requester_main_route_table_id" {
  type = string
  description = "The main route table id of the requesting VPC"
}

variable "accepter_main_route_table_id" {
  type = string
  description = "The main route table id of the accepting VPC"
}

variable "requester_allow_remote_vpc_dns_resolution" {
  type = string
  description = "A boolean flag to dis-/allow remote vpc DNS resolution"
  default = true
}

variable "accepter_allow_remote_vpc_dns_resolution" {
  type = string
  description = "A boolean flag to dis-/allow remote vpc DNS resolution"
  default = true
}
