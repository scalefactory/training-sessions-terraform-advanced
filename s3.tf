###########################
resource aws_s3_bucket data_source {
  bucket = "${var.name}-data-source-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}

resource aws_s3_bucket_notification bucket_notification {
  bucket = aws_s3_bucket.data_source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.updater.arn
    filter_suffix       = ".json"

    events = [
      "s3:ObjectCreated:*",
    ]
  }

  # We need the Lambda permissions to be in place before setting up the
  # notification.
  depends_on = [
    aws_lambda_permission.allow_bucket,
  ]
}

resource aws_s3_bucket_public_access_block block {
  bucket                  = aws_s3_bucket.data_source.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource aws_s3_account_public_access_block block {
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Only one set of public access block changes can be made at a time, so we
  # depend on the one above here.
  # This could be removed to introduce a race condition and possible errors
  # from the API.
  depends_on = [
    aws_s3_bucket_public_access_block.block,
  ]
}
