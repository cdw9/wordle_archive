##### wainwright-photography
resource "aws_route53_zone" "zone" {
  name = "w.summerofpants.com"
}

resource "aws_route53_record" "cert1" {
  zone_id = aws_route53_zone.zone.id
  name    = "_c8744ef7ff1592becade6f514c2eb4a6"
  ttl     = 600
  type    = "CNAME"
  records = ["_7550d1551923dd536ee0dbe8b3e0c154.snfqtctrdh.acm-validations.aws."]
}

resource "aws_route53_record" "cert2" {
  zone_id = aws_route53_zone.zone.id
  name    = "_861d88a42aa8c5ebaffbeaee03be377b.2a57j77niyf4wnq2wqmhvps7i2c4l68"
  ttl     = 600
  type    = "CNAME"
  records = ["_13c734e9d7e4c59dde395df8991265f4.snfqtctrdh.acm-validations.aws."]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.id
  name    = "@"
  ttl     = 600
  type    = "CNAME"
  records = ["cxqpgns6ae.us-east-1.awsapprunner.com"]
}
