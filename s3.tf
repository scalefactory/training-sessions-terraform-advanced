###########################
resource aws_s3_bucket data_source {
  bucket = "${var.name}-data-source"
}

resource aws_s3_bucket_notification bucket_notification {
  bucket = aws_s3_bucket.data_source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.updater.arn
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"

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
