

data "aws_route53_zone" "selected" {
  name         = "${var.domain_name}"
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "iac.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.api.public_ip]
}