locals {
  vcn_cidr          = module.oci_network.vcn.cidr_block  # = "192.168.0.0/16"
  public_cidr       = cidrsubnet(local.vcn_cidr, 8, 100) # = "192.168.100.0/24"
  private_cidr      = cidrsubnet(local.vcn_cidr, 8, 200) # = "192.168.200.0/24"
  dhcp_options_id   = module.oci_network.vcn.default_dhcp_options_id
  security_list_ids = [module.oci_network.vcn.default_security_list_id]
}

module "oci_subnets" {
  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-subnet"

  default_compartment_id = var.default_compartment_id
  vcn_id                 = module.oci_network.vcn.id
  vcn_cidr               = local.vcn_cidr

  subnets = {
    subnet_public = {
      compartment_id    = null
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
      route_table_id    = module.oci_network.route_tables.rt_public.id
      security_list_ids = local.security_list_ids
    }

    subnet_private = {
      compartment_id    = null
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
      dhcp_options_id   = local.dhcp_options_id
      route_table_id    = module.oci_network.route_tables.rt_private.id
      security_list_ids = local.security_list_ids
    }
  }
}
