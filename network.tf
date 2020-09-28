# VCN
resource "oci_core_vcn" "oci_vcn" {
  cidr_block     = var.vcn.cidr_block
  compartment_id = var.compartment.prod_id
  display_name   = var.vcn.display_name
  dns_label      = var.vcn.dns_label

  # true: destroyコマンドで削除不可 false: destroyコマンドで削除可能
  lifecycle {
      prevent_destroy = false
  }
}

# Internet Gateway
resource "oci_core_internet_gateway" "oci_igw" {
    compartment_id = var.compartment.prod_id

    # 上記で作成したVCNのidを利用
    vcn_id = oci_core_vcn.oci_vcn.id
    display_name = var.internet_gateway.display_name

    lifecycle {
        prevent_destroy = false
    }
}

# NAT Gateway
resource "oci_core_nat_gateway" "oci_ngw" {
    compartment_id = var.compartment.prod_id
    vcn_id = oci_core_vcn.oci_vcn.id
    display_name = var.nat_gateway.display_name

    lifecycle {
        prevent_destroy = false
    }
}

# Service Gateway
resource "oci_core_service_gateway" "oci_sgw" {
    compartment_id = var.compartment.prod_id
    services {
        service_id = data.oci_core_services.all_services.services.1.id
    }
    vcn_id = oci_core_vcn.oci_vcn.id
    display_name = var.service_gateway.display_name

    lifecycle {
        prevent_destroy = false
    }
}

data "oci_core_services" "all_services" {
}

# route table (public)
resource "oci_core_route_table" "oci_rt01" {
    compartment_id = var.compartment.prod_id

    # 上記で作成したInternet Gatewayのidを利用
    route_rules {
        network_entity_id = oci_core_internet_gateway.oci_igw.id
        destination = "0.0.0.0/0"
    }
    vcn_id = oci_core_vcn.oci_vcn.id
    display_name = var.route_public.display_name

    lifecycle {
        prevent_destroy = false
    }
}

# route table (private)
resource "oci_core_route_table" "oci_rt02" {
    compartment_id = var.compartment.prod_id

    # 上記で作成したNAT Gatewayのidを利用
    route_rules {
        network_entity_id = oci_core_nat_gateway.oci_ngw.id
        destination = "0.0.0.0/0"
    }
    vcn_id = oci_core_vcn.oci_vcn.id
    display_name = var.route_private.display_name

    lifecycle {
        prevent_destroy = false
    }

}

# Subent(subnet_pub)
resource "oci_core_subnet" "subnet_pub" {
    cidr_block = var.subnet_pub.cidr_block
    display_name = var.subnet_pub.display_name
    dns_label = var.subnet_pub.dns_label
    prohibit_public_ip_on_vnic = var.subnet_pub.prohibit_public_ip_on_vnic
    compartment_id = var.compartment.prod_id
    vcn_id = oci_core_vcn.oci_vcn.id
    route_table_id = oci_core_route_table.oci_rt01.id
    dhcp_options_id = oci_core_vcn.oci_vcn.default_dhcp_options_id

    # Network Security Groupで制御するため、"Default Security List for ~"を指定する
    security_list_ids = [oci_core_vcn.oci_vcn.default_security_list_id]

    lifecycle {
        prevent_destroy = false
    }
}

# Subent(subnet_priv)
resource "oci_core_subnet" "subnet_priv" {
    cidr_block = var.subnet_priv.cidr_block
    display_name = var.subnet_priv.display_name
    dns_label = var.subnet_priv.dns_label
    prohibit_public_ip_on_vnic = var.subnet_priv.prohibit_public_ip_on_vnic
    compartment_id = var.compartment.prod_id
    vcn_id = oci_core_vcn.oci_vcn.id
    route_table_id = oci_core_route_table.oci_rt02.id
    dhcp_options_id = oci_core_vcn.oci_vcn.default_dhcp_options_id
    security_list_ids = [oci_core_vcn.oci_vcn.default_security_list_id]

    lifecycle {
        prevent_destroy = false
    }
}

