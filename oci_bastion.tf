module "oci_bastions" {
  source = "https://github.com/yuki9431/terraform-oci-tdf-bastion-service.git"

  default_compartment_id = var.default_compartment_id

  bastions = {
    bastion = {
      bastion_type = "STANDARD"
      compartment_id = null
      target_subnet_id = module.oci_subnets.subnets.subnet_private.id

      client_cidr_block_allow_list = ["0.0.0.0/0"]
      defined_tags = null
      freeform_tags = null
      max_session_ttl_in_seconds    = "10800" # 180 minutes
      phone_book_entry = null
      static_jump_host_ip_addresses = null
    }
  }
}
