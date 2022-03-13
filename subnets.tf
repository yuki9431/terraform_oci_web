# subnets
locals {
  vcn_cidr          = module.vcn.vcn_all_attributes.cidr_blocks[0] # = "192.168.0.0/16"
  public_cidr       = cidrsubnet(local.vcn_cidr, 8, 100)           # = "192.168.100.0/24"
  private_cidr      = cidrsubnet(local.vcn_cidr, 8, 200)           # = "192.168.200.0/24"
  dhcp_options_id   = module.vcn.vcn_all_attributes.default_dhcp_options_id
  security_list_ids = [module.vcn.vcn_all_attributes.default_security_list_id]

  subnets = {
    public_subnet = {
      compartment_id    = var.compartment_id
      defined_tags      = null
      freeform_tags     = null
      dynamic_cidr      = null
      cidr              = local.public_cidr
      cidr_len          = null
      cidr_num          = null
      enable_dns        = null
      dns_label         = null
      private           = false
      ad                = null
      dhcp_options_id   = local.dhcp_options_id
      route_table_id    = module.vcn.ig_route_id
      security_list_ids = local.security_list_ids
    }

    private_subnet = {
      compartment_id    = var.compartment_id
      defined_tags      = null
      freeform_tags     = null
      dynamic_cidr      = null
      cidr              = local.private_cidr
      cidr_len          = null
      cidr_num          = null
      enable_dns        = null
      dns_label         = null
      private           = true
      ad                = null
      dhcp_options_id   = module.vcn.vcn_all_attributes.default_dhcp_options_id
      route_table_id    = module.vcn.nat_route_id
      security_list_ids = local.security_list_ids
    }
  }
}

module "subnets" {
  source = "git@github.com:oracle-terraform-modules/terraform-oci-tdf-subnet.git"

  default_compartment_id = var.compartment_id
  vcn_id                 = module.vcn.vcn_id
  vcn_cidr               = local.vcn_cidr

  subnets = local.subnets
}
