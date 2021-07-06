resource "aws_s3_bucket" "website" {
  bucket = "${var.name}-website-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  acl    = "public-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  website {
    index_document = "index.html"
  }

  # Must force destroy since buckets will have objects after the training
  # session.
  force_destroy = true
}

resource "aws_s3_bucket_object" "index" {
  bucket           = aws_s3_bucket.website.bucket
  acl              = "public-read"
  key              = "index.html"
  content          = local.website_content
  content_language = "en-GB"
  content_type     = "text/html"
  etag             = md5(local.website_content)
}
