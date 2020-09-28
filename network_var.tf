# protocol number
variable "protocol" {
  default = {
    ICMP = "1" 
    TCP = "6"
    UDP = "17"
    ICMPv6 = "58"
  }
}

# VCN
variable "vcn" {
  default = {
    cidr_block = "192.168.0.0/16"
    display_name = "oci_vcn"
    dns_label = "ocivcn"
  }
}

# internet gateway
variable "internet_gateway"  {
  default = {
    display_name = "oci_igw"
  }
}

# nat gateway
variable "nat_gateway"  {
  default = {
    display_name = "oci_ingw"
  }
}

# service gateway
variable "service_gateway" {
  default = {
    display_name = "oci_isgw"
  }
}

# route table
variable "route_public" {
  default = {
    display_name = "rt01"
  }
}

variable "route_private" {
  default = {
    display_name = "priv_rt01"
  }
}

# subnet_pub
variable "subnet_pub" {
  default = {
    cidr_block = "192.168.100.0/24"
    display_name = "subnet_pub"
    dns_label = "subnetpub"
    prohibit_public_ip_on_vnic = "false"
  }
}

# subnet_priv
variable "subnet_priv" {
  default = {
    cidr_block = "192.168.200.0/24"
    display_name = "subnet_priv"
    dns_label = "subnetpriv"
    prohibit_public_ip_on_vnic = "true"
  }
}
