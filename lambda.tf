# Allow lambda call
resource aws_lambda_permission allow_bucket {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_name
  # aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_source.arn
}
