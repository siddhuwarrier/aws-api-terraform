resource "aws_s3_bucket" "main" {
  bucket = "docs.${var.env}.${var.hosted_zone_dns}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    origin_id   = "docs.${var.env}.${var.hosted_zone_dns}"
    domain_name = "docs.${var.env}.${var.hosted_zone_dns}.s3.amazonaws.com"
  }

  # If using route53 aliases for DNS we need to declare it here too, otherwise we'll get 403s.
  aliases = ["docs.${var.env}.${var.hosted_zone_dns}"]

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "docs.${var.env}.${var.hosted_zone_dns}"

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # The cheapest priceclass
  price_class = "PriceClass_100"

  # This is required to be specified even if it's not used.
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = "	arn:aws:acm:us-east-1:686080651210:certificate/cbbd4b25-7130-44aa-9288-d55afec2293f"
    ssl_support_method  = "sni-only"
  }
}

resource "aws_route53_record" "main" {
  name    = "docs.${var.env}.${var.hosted_zone_dns}"
  type    = "A"
  zone_id = var.hosted_zone_id

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

data "template_file" "main" {
  template = <<EOF
curl -L https://github.com/swagger-api/swagger-ui/archive/${var.swagger_ui_version}.tar.gz -o /tmp/swagger-ui.tar.gz
mkdir -p /tmp/swagger-ui
tar --strip-components 1 -C /tmp/swagger-ui -xf /tmp/swagger-ui.tar.gz
aws s3 sync --region ${var.aws_region} --acl public-read /tmp/swagger-ui/dist s3://${aws_s3_bucket.main.bucket} --delete
rm -rf /tmp/swagger-ui
EOF
}

resource "null_resource" "main" {
  triggers = {
    rendered_template = data.template_file.main.rendered
    version           = var.swagger_ui_version
  }

  provisioner "local-exec" {
    command = data.template_file.main.rendered
  }
}
