###########################
resource aws_s3_bucket data_source {
  bucket = "${var.name}-data-source"
}

resource aws_s3_bucket_notification bucket_notification {
  bucket = aws_s3_bucket.data_source.id

  lambda_function {
    lambda_function_arn = local.lambda_name
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".log"

    events = [
      "s3:ObjectCreated:*",
    ]
  }

  depends_on = [
    aws_lambda_permission.allow_bucket,
  ]
}
