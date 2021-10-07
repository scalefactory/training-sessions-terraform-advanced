resource "aws_s3_bucket" "website" {
  bucket = "website-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  acl    = "public-read"


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
  etag             = md5(local.website_content)
  content_language = "en-GB"
  content_type     = "text/html"
}

locals {
  website_content = <<EOT
        <html><head>
        <title>Hello World</title>
        </head>
        <body>
        <h1>Hello World</h1>
        </body>
        </html>
  EOT
}
