resource "aws_route53_zone" "hostedzone" {
  name = var.domain_name
  comment = var.comment

  tags = var.hostedzone_tags
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.cert_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.cert_tags

}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hostedzone.zone_id
}
