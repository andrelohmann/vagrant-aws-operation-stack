/**
 * VPC ID
 */
variable "name" {
  type = string
  description = "SG Name"
}

variable "port" {
  type = string
  description = "Public port, to gain access to"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}
