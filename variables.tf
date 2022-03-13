# provider identity parameters
variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the OCI region where resources will be created"
  type        = string
}

# general oci parameters

variable "default_compartment_id" {
  type        = string
  description = "compartment id where to create all resources"
}

variable "tenancy_ocid" {
  type        = string
  description = "tenancy id where to create all resources"
}

variable "user_ocid" {
  type        = string
  description = "user id where to access OCI API"
}

variable "fingerprint" {
  type        = string
  description = "fingerprint id where to access OCI API"
}

variable "private_key_path" {
  type        = string
  description = "private key path to to access OCI API"
}
