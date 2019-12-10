# Terraform Public Port SecurityGroup Module

This module creates a SecurityGroup on the given VPC, that allows public access from the given port.

The following variables need to be defined, when using this module:

        module "security_group" {
          source                = "../modules/public_port_sg"
          name                  = "ssh"
          port                  = "22"
          vpc_id                = "xxx"
        }

The Module then outputs:

        id # SecurityGroup ID
