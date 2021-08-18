terraform {
  required_providers {
    acme = {
      source = "vancluever/acme"
      configuration_aliases = [acme.production]
    }
  }
}

resource "acme_certificate" "certificate" {

  provider        = acme.production
  account_key_pem = var.account_key_pem
  common_name     = var.common_name

  dns_challenge {
    provider = "route53"
  }
}
