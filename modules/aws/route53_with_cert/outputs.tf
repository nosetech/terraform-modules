output "zone_id" {
  value = aws_route53_zone.hostedzone.zone_id
}

output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}
