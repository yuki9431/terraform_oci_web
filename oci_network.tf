# oci_network
locals {
  next_hop_ids = {
    "igw"   = module.oci_network.igw.id
    "natgw" = module.oci_network.natgw.id
  }
}

module "oci_network" {
  source                 = "git@github.com:oracle-terraform-modules/terraform-oci-tdf-network.git"
  default_compartment_id = var.default_compartment_id

  vcn_options = {
    display_name   = "terraform_vcn"
    cidr           = "192.168.0.0/16"
    enable_dns     = true
    dns_label      = "terraformvcn"
    compartment_id = null
    defined_tags   = null
    freeform_tags  = null
  }

  create_igw   = true
  create_natgw = true

  route_tables = {
    rt_private = {
      compartment_id = null
      defined_tags   = null
      freeform_tags  = null
      route_rules = [
        {
          dst         = "0.0.0.0/0"
          dst_type    = "CIDR_BLOCK"
          next_hop_id = local.next_hop_ids["natgw"]
        }
      ]
    },
    rt_public = {
      compartment_id = null
      defined_tags   = null
      freeform_tags  = null
      route_rules = [
        {
          dst         = "0.0.0.0/0"
          dst_type    = "CIDR_BLOCK"
          next_hop_id = local.next_hop_ids["igw"]
        }
      ]
    }
  }
}
