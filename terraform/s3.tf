resource "aws_s3_bucket" "aw" {
  bucket_prefix = "wordle-archive"
}

resource "aws_s3_bucket_policy" "aw" {
  bucket = aws_s3_bucket.aw.id
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${aws_cloudfront_origin_access_identity.aw.iam_arn}"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.aw.arn}/*"
        }
    ]
}
EOF
}

resource "aws_cloudfront_origin_access_identity" "aw" {
  comment = "wordle archive"
}

resource "aws_cloudfront_distribution" "aw" {
  aliases             = ["a.w.summerofpants.com"]
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  default_root_object = "wordle_archive/index.html"

  origin {
    domain_name = aws_s3_bucket.aw.bucket_regional_domain_name
    origin_id   = "s3"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.aw.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    target_origin_id       = "s3"
    cached_methods         = ["GET", "HEAD"]
    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.aw.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_acm_certificate" "aw" {
  provider          = aws.us-east-1
  domain_name       = "a.w.summerofpants.com"
  validation_method = "DNS"
}