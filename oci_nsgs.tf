locals {
  protocols = {
    ALL    = "all"
    ICMP   = "1"
    TCP    = "6"
    UDP    = "17"
    ICMPv6 = "58"
  }

  ipaddr = {
    anywhere       = "0.0.0.0/0"
    subnet_private = "192.168.200.0/24"
  }

  empty_nsg = {
    compartment_id = null
    defined_tags   = null
    freeform_tags  = null
    ingress_rules  = null
    egress_rules   = null
    description    = null
  }
}

#
# NOTE: 通信ポリシー(module standalone_nsg_rules)で、NSGの相互参照があるため
#       通信ポリシーを定義する前に、NSGだけ作成する必要がある
#       相互参照がない場合は、NSGと通信ポリシーはまとめて作成可能
#

module "oci_nsgs" {
  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-network-security"

  default_compartment_id = var.default_compartment_id
  vcn_id                 = module.oci_network.vcn.id

  nsgs = {
    nsg_web     = local.empty_nsg
    nsg_managed = local.empty_nsg
    nsg_lb      = local.empty_nsg
  }
}

# NSG作成後に通信ポリシーを追加する
module "standalone_nsg_rules" {
  source = "github.com/oracle-terraform-modules/terraform-oci-tdf-network-security"

  for_each = {
    nsg_web = {
      egress_rules = [{
        nsg_id      = module.oci_nsgs.nsgs.nsg_web.id
        description = "Egressは全て許可する。"
        stateless   = false
        protocol    = local.protocols.ALL
        dst         = local.ipaddr.anywhere
        dst_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port    = null
        icmp_code   = null
        icmp_type   = null
      }]

      ingress_rules = [{

        nsg_id      = module.oci_nsgs.nsgs.nsg_web.id
        description = "LBからHTTP通信を許可する"
        stateless   = false
        protocol    = local.protocols.TCP
        src         = module.oci_nsgs.nsgs.nsg_lb.id
        src_type    = "NETWORK_SECURITY_GROUP"
        src_port    = null
        dst_port = {
          min = 80
          max = 80
        }
        icmp_code = null
        icmp_type = null

        }, {

        nsg_id      = module.oci_nsgs.nsgs.nsg_web.id
        description = "同サブネットからの通信は全て許可する"
        stateless   = false
        protocol    = local.protocols.ALL
        src         = local.ipaddr.subnet_private
        src_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port    = null
        icmp_code   = null
        icmp_type   = null

      }]
    }

    nsg_managed = {
      egress_rules = [{
        nsg_id      = module.oci_nsgs.nsgs.nsg_managed.id
        description = "Egressは全て許可する。"
        stateless   = false
        protocol    = local.protocols.ALL
        dst         = local.ipaddr.anywhere
        dst_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port    = null
        icmp_code   = null
        icmp_type   = null
      }]

      ingress_rules = [{

        nsg_id      = module.oci_nsgs.nsgs.nsg_managed.id
        description = "LBからHTTP通信を許可する(Zabbix管理画面)"
        stateless   = false
        protocol    = local.protocols.TCP
        src         = module.oci_nsgs.nsgs.nsg_lb.id
        src_type    = "NETWORK_SECURITY_GROUP"
        src_port    = null
        dst_port = {
          min = 80
          max = 80
        }
        icmp_code = null
        icmp_type = null

        }, {

        nsg_id      = module.oci_nsgs.nsgs.nsg_managed.id
        description = "同サブネットからの通信は全て許可する"
        stateless   = false
        protocol    = local.protocols.ALL
        src         = local.ipaddr.subnet_private
        src_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port    = null
        icmp_code   = null
        icmp_type   = null

      }]
    }

    nsg_lb = {
      egress_rules = [{
        nsg_id      = module.oci_nsgs.nsgs.nsg_lb.id
        description = "Egressは全て許可する。"
        stateless   = false
        protocol    = local.protocols.ALL
        dst         = local.ipaddr.anywhere
        dst_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port    = null
        icmp_code   = null
        icmp_type   = null
      }]

      ingress_rules = [{

        nsg_id      = module.oci_nsgs.nsgs.nsg_lb.id
        description = "外部からHTTP通信を許可する"
        stateless   = false
        protocol    = local.protocols.TCP
        src         = local.ipaddr.anywhere
        src_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port = {
          min = 80
          max = 80
        }
        icmp_code = null
        icmp_type = null

        }, {

        nsg_id      = module.oci_nsgs.nsgs.nsg_lb.id
        description = "外部からHTTPS通信を許可する"
        stateless   = false
        protocol    = local.protocols.TCP
        src         = local.ipaddr.anywhere
        src_type    = "CIDR_BLOCK"
        src_port    = null
        dst_port = {
          min = 443
          max = 443
        }
        icmp_code = null
        icmp_type = null

      }]
    }
  }

  default_compartment_id = var.default_compartment_id
  vcn_id                 = module.oci_network.vcn.id

  standalone_nsg_rules = {
    ingress_rules = each.value.ingress_rules
    egress_rules  = each.value.egress_rules
  }
}
