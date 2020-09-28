# nsg web
resource "oci_core_network_security_group" "nsg_web" {
  compartment_id = var.compartment.prod_id
  vcn_id = oci_core_vcn.oci_vcn.id

  display_name = "nsg_web"
}

# Egressは全て許可する
resource "oci_core_network_security_group_security_rule" "nsg_web_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.nsg_web.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

# 同セグメントの全ての通信を許可する
resource "oci_core_network_security_group_security_rule" "nsg_web_security_rule_2" {
  description = "同セグメントの全ての通信を許可する"
  network_security_group_id = oci_core_network_security_group.nsg_web.id
  direction   = "INGRESS"
  protocol    = "all"
  source = var.subnet_priv.cidr_block
  source_type = "CIDR_BLOCK"
}

# LBからのWEBアクセスを許可
resource "oci_core_network_security_group_security_rule" "nsg_web_security_rule_3" {
  description = "LBからのWEBアクセスを許可する"

  # 依存関係を明記
  depends_on = [oci_core_network_security_group.nsg_lb]

  network_security_group_id = oci_core_network_security_group.nsg_web.id
  direction   = "INGRESS"
  protocol    = var.protocol.TCP
  source = oci_core_network_security_group.nsg_lb.id
  source_type = "NETWORK_SECURITY_GROUP"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}