# nsg load balancer
resource "oci_core_network_security_group" "nsg_lb" {
  compartment_id = var.compartment.prod_id
  vcn_id = oci_core_vcn.oci_vcn.id

  display_name = "nsg_lb"
}

# Egressは全て許可する
resource "oci_core_network_security_group_security_rule" "nsg_lb_security_rule_1" {
  network_security_group_id = oci_core_network_security_group.nsg_lb.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

# webアクセス許可
resource "oci_core_network_security_group_security_rule" "nsg_lb_security_rule_2" {
  network_security_group_id = oci_core_network_security_group.nsg_lb.id

  direction   = "INGRESS"
  protocol    = var.protocol.TCP
  source = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# SSHアクセス許可
resource "oci_core_network_security_group_security_rule" "nsg_lb_security_rule_3" {
  network_security_group_id = oci_core_network_security_group.nsg_lb.id

  direction   = "INGRESS"
  protocol    = var.protocol.TCP
  source = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}