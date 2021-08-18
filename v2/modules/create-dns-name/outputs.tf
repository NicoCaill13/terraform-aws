output "dns" {
  value = data.aws_route53_zone.main
}

output "fqdn_domain_name" {
  value = "${aws_route53_record.letsencrypt-terraform.fqdn}"
}