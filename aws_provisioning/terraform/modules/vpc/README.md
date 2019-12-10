# Terraform VPC Module

This module allows the setup of a vpc and its subnets.

The following variables need to be defined, when using this module:

        module "your-vpc" {
          source                = "../modules/terraform-module-vpc"
          cidr                  = "x.x.x.x/y"
          name                  = "your-vpc"
          environment           = "your-environment"
          availability_zones    = ["us-west-1a", "us-west-1b", "us-west-1c"]
          private_subnets       = {
            "us-west-1a" = "a.a.a.a/n"
            "us-west-1b" = "b.b.b.b/n"
            "us-west-1c" = "c.c.c.c/n"
          }
        }

Additionally variables:

        module "your-vpc" {
          ...
          public_subnets        = {
            "us-west-1a" = "a.a.a.a/n"
            "us-west-1b" = "b.b.b.b/n"
            "us-west-1c" = "c.c.c.c/n"
          }
        }

The Module then outputs:

        id # VPC ID
        main-route-table-id # VPCs main route table id
        subnets # a comma-separated list of subnet IDs
