# Our lambda function
resource "aws_lambda_function" "updater" {
  provider = aws.lambda_admin

  filename         = data.archive_file.updater.output_path
  function_name    = local.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "updater.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.updater.output_path)
  timeout          = 30

  environment {
    variables = {
      dynamodb_table = aws_dynamodb_table.data_set.name
      keys           = "name"
      s3_bucket      = aws_s3_bucket.data_source.bucket
    }
  }
}

# Allow lambda call from S3 bucket
resource "aws_lambda_permission" "allow_bucket" {
  provider = aws.lambda_admin

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.updater.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_source.arn
  statement_id  = "AllowExecutionFromS3Bucket"
}
