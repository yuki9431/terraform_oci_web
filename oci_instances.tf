module "oci_instances" {
  source = "https://github.com/yuki9431/terraform-oci-tdf-compute-instance.git"

  default_compartment_id = var.default_compartment_id

  instances = {
    instance_web01 = {
      ad             = null #0-AD1, 1-AD2, 3-AD3 RequiredRequired
      compartment_id = var.default_compartment_id
      shape          = "VM.Standard.E2.1.Micro"

      subnet_id = module.oci_subnets.subnets.subnet_private.id

      is_monitoring_disabled = null

      assign_public_ip    = false
      vnic_defined_tags   = null
      vnic_display_name   = null
      vnic_freeform_tags  = null
      nsg_ids             = [module.oci_nsgs.nsgs.nsg_web.id]
      private_ip          = cidrhost(module.oci_subnets.subnets.subnet_private.cidr_block, 10)
      skip_src_dest_check = null

      defined_tags          = null
      extended_metadata     = null
      fault_domain          = null
      freeform_tags         = null
      hostname_label        = null
      ipxe_script           = null
      pv_encr_trans_enabled = null

      ssh_authorized_keys = ["./keys/ssh.key.pub"] #ex: ["/path/public-key.pub"]
      ssh_private_keys    = ["./keys/ssh.key"]     #ex: ["/path/private-key"]
      bastion_ip          = null
      user_data           = null #base64encode(file("bootstrap.sh"))

      // See https://docs.cloud.oracle.com/iaas/images/
      // Oracle-provided image "CentOS-8-2021.12.03-0"
      image_name             = "CentOS-8-2021.12.03-0"
      source_id              = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaarbv25hiqjivdj2rn5vvlkp3glxcn3zai4zxhy44xodqhsf6czapa"
      mkp_image_name         = null
      mkp_image_name_version = null
      source_type            = null
      boot_vol_size_gbs      = null
      kms_key_id             = null

      preserve_boot_volume = null
      instance_timeout     = null
      sec_vnics            = null #{} #
      mount_blk_vols       = false
      block_volumes        = null
      cons_conn_create     = null
      cons_conn_def_tags   = null
      cons_conn_free_tags  = null

      plugins_config = {
        bastion = "ENABLED"
      }

    },
    instance_managed01 = {
      ad             = null #0-AD1, 1-AD2, 3-AD3 RequiredRequired
      compartment_id = var.default_compartment_id
      shape          = "VM.Standard.E2.1.Micro"

      subnet_id = module.oci_subnets.subnets.subnet_private.id

      is_monitoring_disabled = null

      assign_public_ip    = false
      vnic_defined_tags   = null
      vnic_display_name   = null
      vnic_freeform_tags  = null
      nsg_ids             = [module.oci_nsgs.nsgs.nsg_web.id]
      private_ip          = cidrhost(module.oci_subnets.subnets.subnet_private.cidr_block, 20)
      skip_src_dest_check = null

      defined_tags          = null
      extended_metadata     = null
      fault_domain          = null
      freeform_tags         = null
      hostname_label        = null
      ipxe_script           = null
      pv_encr_trans_enabled = null

      ssh_authorized_keys = ["./keys/ssh.key.pub"] #ex: ["/path/public-key.pub"]
      ssh_private_keys    = ["./keys/ssh.key"]     #ex: ["/path/private-key"]
      bastion_ip          = null
      user_data           = null #base64encode(file("bootstrap.sh"))

      // See https://docs.cloud.oracle.com/iaas/images/
      // Oracle-provided image "CentOS-8-2021.12.03-0"
      image_name             = "CentOS-8-2021.12.03-0"
      source_id              = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaarbv25hiqjivdj2rn5vvlkp3glxcn3zai4zxhy44xodqhsf6czapa"
      mkp_image_name         = null
      mkp_image_name_version = null
      source_type            = null
      boot_vol_size_gbs      = null
      kms_key_id             = null

      preserve_boot_volume = null
      instance_timeout     = null
      sec_vnics            = null #{} #
      mount_blk_vols       = false
      block_volumes        = null
      cons_conn_create     = null
      cons_conn_def_tags   = null
      cons_conn_free_tags  = null

      plugins_config = {
        bastion = "ENABLED"
      }

    }
  }
}
