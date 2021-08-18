terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
    }
    acme = {
      source                = "vancluever/acme"
      configuration_aliases = [acme.production]
    }
  }
}
resource "tls_private_key" "acme_registration_private_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"

  lifecycle {
    prevent_destroy = true
  }
}

# Set up a registration using the registration private key
resource "acme_registration" "reg" {
  provider        = acme.production
  account_key_pem = tls_private_key.acme_registration_private_key.private_key_pem
  email_address   = var.acme_email
}
