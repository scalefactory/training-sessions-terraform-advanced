resource "aws_s3_bucket" "website" {
  bucket = "website-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"

  website {
    index_document = "index.html"
  }

  # Must force destroy since buckets will have objects after the training
  # session.
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_s3_public_read" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.allow_s3_public_read.json

  depends_on = [
    aws_s3_bucket.website,
    aws_s3_bucket_ownership_controls.website,
    aws_s3_bucket_public_access_block.website,
  ]

}

data "aws_iam_policy_document" "allow_s3_public_read" {
  statement {
    sid       = "PublicReadGetObject"
    effect    = "Allow"
    resources = ["${aws_s3_bucket.website.arn}/*"]
    actions   = ["s3:GetObject"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
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
