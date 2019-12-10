# Terraform VPC Peering Module

This module allows to peer two VPCs.

The following variables need to be defined, when using this module:

        module "your-peering-connection" {
          source                                      = "../modules/terraform-module-vpc_peering"
          connection_name                             = "requester2accepter"
          account_id                                  = "your-aws-account-id"
          requester_id                                = "requester-vpc-id"
          accepter_id                                 = "accepter-vpc-id"
          requester_cidr_block                        = "x.x.x.x/z"
          accepter_cidr_block                         = "y.y.y.y/z"
          requester_main_route_table_id               = "requester-vpc-main-route-table-id"
          accepter_main_route_table_id                = "accepter-vpc.main-route-table-id"
          requester_allow_remote_vpc_dns_resolution   = false
          accepter_allow_remote_vpc_dns_resolution    = false
        }

The Module then outputs:

        connection-id # The Peering Connection id
