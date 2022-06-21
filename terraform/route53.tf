##### wainwright-photography
resource "aws_route53_zone" "zone" {
  name = "w.summerofpants.com"
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.aw.domain_validation_options :
    dvo.resource_record_name => dvo.resource_record_value
  }
  zone_id = aws_route53_zone.zone.id
  name    = each.key
  ttl     = 600
  type    = "CNAME"
  records = [each.value]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.id
  name    = "a"
  ttl     = 600
  type    = "CNAME"
  records = [aws_cloudfront_distribution.aw.domain_name]
}
