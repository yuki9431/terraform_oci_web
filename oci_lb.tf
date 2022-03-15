module "load_balancer" {
  source = "https://github.com/oracle-terraform-modules/terraform-oci-tdf-lb.git"

  default_compartment_id = var.default_compartment_id

  lb_options = {
    display_name   = "lb_web"
    compartment_id = null
    shape          = "10Mbps-Micro"
    subnet_ids     = [module.oci_subnets.subnets.subnet_public.id]
    private        = false
    nsg_ids        = [module.oci_nsgs.nsgs.nsg_lb.id]
    defined_tags   = null
    freeform_tags  = null
  }

  health_checks = {
    basic_http = {
      protocol            = "HTTP"
      interval_ms         = 1000
      port                = 80
      response_body_regex = ".*"
      retries             = 3
      return_code         = 200
      timeout_in_millis   = 3000
      url_path            = "/"
    }
  }

  backend_sets = {
    bs_web = {
      policy             = "ROUND_ROBIN"
      health_check_name  = "basic_http"
      enable_persistency = false
      enable_ssl         = false

      cookie_name             = null
      disable_fallback        = null
      certificate_name        = null
      verify_depth            = null
      verify_peer_certificate = null

      backends = {
        web01 = {
          ip      = module.oci_instances.instance.instance_web01.private_ip
          port    = 80
          backup  = false
          drain   = false
          offline = false
          weight  = 1
        }
      }
    }
  }

  listeners = {
    listeners_web = {
      default_backend_set_name = "bs_web"
      port                     = 80
      protocol                 = "HTTP"
      idle_timeout             = 180
      hostnames                = null
      path_route_set_name      = null
      rule_set_names           = null
      enable_ssl               = false
      certificate_name         = null
      verify_depth             = 5
      verify_peer_certificate  = true
    }
  }
}
