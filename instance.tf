# FDの数を設定, 2020年現在FD1 ~ FD3があるため3を設定する
variable "number_fault_domain" {
  default = 3
}

# FDの数が増えた場合は、定義を増やすこと
variable "fault_domain" {
  default = {
    "0" = "FAULT-DOMAIN-1"
    "1" = "FAULT-DOMAIN-2"
    "2" = "FAULT-DOMAIN-3"
  }
}

# 参考URL https://docs.us-phoenix-1.oraclecloud.com/images/
# 下記はOracle-provided image "Oracle-Linux-7.8-2020.08.26-0"を選択している
variable "instance_image_ocid" {
  default = {
    ap-osaka-1   = "ocid1.image.oc1.ap-osaka-1.aaaaaaaa56hhfvilomwi52u4hc7kwdgeqiw2jtiaeov2ndz6vab6c6beui6a"
    ap-tokyo-1   = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaadr3nqxb3xmunjeqvm5o5ywj7posqxwei6k3f7bbroytjfcpurb2a"
  }
}

# WEBサーバの設定値
variable "web" {
  default = {
    # サーバ数
    count = 2

    # CIDRブロック"192.168.100.XX"のXXを指定する
    # 10の場合は、192.168.100.1Xから順番に割り振られる
    # 1桁の場合は正常に動作しないため、10の倍数で指定すること
    # 例 = 20, = 30
    hostnum = 10

    # instance.tfで%02dは数字に置換する
    display_name = "web%02d" # = webXX
    shape = "VM.Standard2.1"

    assign_public_ip = "false"
    ssh_authorized_keys = "/home/opc/.ssh/id_rsa.pub"
  
    # instance_image_ocidに対応させる
    region = "ap-tokyo-1"

    source_type = "image"
    boot_volume_size_in_gbs = "50"
  }
}

# WEBサーバ
resource "oci_core_instance" "web" {

  # インスタンスの作成には、サブネットとネットワークセキュリティグループが必要
  # 依存関係として、対応するサブネットとネットワークセキュリティグループを指定する
  depends_on = [
    oci_core_network_security_group.nsg_web,
    oci_core_subnet.subnet_priv
  ]

  count = var.web.count
  compartment_id = var.compartment.prod_id

  # "count.index % 3"で、余り数字の0から3を順番に選択することでFD1~FD3を交互に設定する
  fault_domain = lookup(var.fault_domain, count.index % var.number_fault_domain) # = FAULT-DOMAIN-x

  # 2020年現在AD1しか存在しないため、FDのように動的にしない
  availability_domain = data.oci_identity_availability_domain.ad.name

  # count.indexは0から始まるので+1する
  display_name = format(var.web.display_name, count.index + 1) # = webXX
  shape = var.web.shape

  create_vnic_details {
    assign_public_ip = var.web.assign_public_ip

    # サーバのプライベートIPを連番以外にしたい場合は書き換えること
    private_ip = cidrhost(var.subnet_priv.cidr_block, var.web.hostnum + count.index) # = 192.168.200.1X

    # インスタンス名と同じにする
    display_name = format(var.web.display_name, count.index + 1) # = webXX
    nsg_ids = [oci_core_network_security_group.nsg_web.id]
    subnet_id = oci_core_subnet.subnet_priv.id
  }

  metadata = {
    ssh_authorized_keys = var.web.ssh_authorized_keys
  }

  source_details {
    source_id = var.instance_image_ocid[var.web.region]
    source_type = var.web.source_type
    boot_volume_size_in_gbs = var.web.boot_volume_size_in_gbs
  }

  # true: destroyコマンドで削除不可 false: destroyコマンドで削除可能
  lifecycle {
    prevent_destroy = false 
  }
}