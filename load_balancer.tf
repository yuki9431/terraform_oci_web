# Load Balancer
resource "oci_load_balancer" "lb" {
  shape          = "10Mbps"
  compartment_id = var.compartment.prod_id
  is_private = "false"

  subnet_ids = [oci_core_subnet.subnet_pub.id]
  network_security_group_ids = [oci_core_network_security_group.nsg_lb.id]

  display_name = "lb"
}

resource "oci_load_balancer_backend_set" "lb_bes1" {
  name             = "lb_bes1"
  load_balancer_id = oci_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "lb_listener1" {
  load_balancer_id         = oci_load_balancer.lb.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.lb_bes1.name
  port                     = 80
  protocol                 = "HTTP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_backend" "lb_be1" {
  count = var.web.count

  load_balancer_id = oci_load_balancer.lb.id
  backendset_name  = oci_load_balancer_backend_set.lb_bes1.name
  ip_address       = oci_core_instance.web[count.index].private_ip
  port             = 80
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}

resource "oci_load_balancer_backend_set" "lb_bes2" {
  name             = "lb_bes2"
  load_balancer_id = oci_load_balancer.lb.id
  policy           = "ROUND_ROBIN"

  health_checker {
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_listener" "lb_listener2" {
  load_balancer_id         = oci_load_balancer.lb.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.lb_bes2.name
  port                     = 22
  protocol                 = "TCP"

  connection_configuration {
    idle_timeout_in_seconds = "2"
  }
}

resource "oci_load_balancer_backend" "lb_be2" {
  count = var.web.count

  load_balancer_id = oci_load_balancer.lb.id
  backendset_name  = oci_load_balancer_backend_set.lb_bes2.name
  ip_address       = oci_core_instance.web[count.index].private_ip
  port             = 22
  backup           = false
  drain            = false
  offline          = false
  weight           = 1
}