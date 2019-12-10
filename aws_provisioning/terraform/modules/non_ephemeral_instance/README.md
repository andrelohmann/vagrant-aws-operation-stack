# Terraform Ephemeral Instance Module

This module allows the setup of an ephemeral instance and attach serveral SGs, as also set some configs.

The following variables need to be defined, when using this module:

        module "your-non-ephemeral-instance" {
          source                      = "../modules/non_ephemeral_instance"
          name                        = "__instance_name__"
          key_name                    = "__deployment_key_pair_name__"
          ami_id                      = "__initial_ami_id__}"
          instance_type               = "__instance_type__"
          vpc_id                      = "__vpc_id__"
          availability_zone           = "__availability_zone__"
          subnet_id                   = "__subnet_id__"
          security_group_ids          = ["__security_group_id__"]
          private_ip                  = "__private_ip__"
          eip_id                      = "__eip_id__"
          eip_ip                      = "__eip_ip__"
          user_groups                 = "__comma_separated_user_groups__"
          zone_id                     = "__zone_id__"
          reverse_zone_id             = "__reverse_zone_id__"
          zone_domain                 = "__zone_domain__"
        }

Additionally variables:

        module "your-non-ephemeral-instance" {
          ...
          volume_size                 = "100"
          volume_type                 = "gp2"
          pausable                    = "False"
        }

The Module then outputs:

        id # Instance ID
