locals {
  lambda_name = "${var.name}_lambda"
  name        = var.name

  website_content = templatefile("templates/index.html", {
    dynamodb_table          = aws_dynamodb_table.data_set.name
    lambda_function_name    = aws_lambda_function.updater.function_name
    lambda_source_code_hash = aws_lambda_function.updater.source_code_hash
    private_bucket          = aws_s3_bucket.data_source.bucket
    title                   = "${data.aws_caller_identity.current.account_id} Infrastructure"
  })
}
