# VCN
module "vcn" {
  source                  = "git@github.com:oracle-terraform-modules/terraform-oci-vcn.git"
  region                  = var.region
  compartment_id          = var.compartment_id
  create_internet_gateway = true
  create_nat_gateway      = true
  vcn_cidrs               = ["192.168.0.0/16"]
  vcn_dns_label           = "terraformvcn"
  vcn_name                = "terraform_vcn"
}
