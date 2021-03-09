locals {
  lambda_name = "${var.name}_lambda"
}

###########################
resource aws_dynamodb_table data_set {
  name           = "${var.name}_data_set"
  hash_key       = "name"
  write_capacity = 1
  read_capacity  = 1

  attribute {
    name = "name"
    type = "S"
  }
}

resource aws_s3_bucket data_source {
  bucket = "${var.name}-data-source"
}

# Create role for Lambda
resource aws_iam_role lambda_role {
  name               = "${var.name}_lambda_role"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

# Attach basic policy
resource aws_iam_role_policy_attachment AWSLambdaBasicExecution {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach dynamodb policy
resource aws_iam_role_policy_attachment LambdaDynamoDB {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource aws_iam_policy dynamodb_policy {
  path   = "/"
  policy = data.aws_iam_policy_document.dynamodb.json
}

# Attach S3 Policy
resource aws_iam_role_policy_attachment LambdaS3 {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}


resource aws_iam_policy s3_policy {
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}

## Allow lambda call
resource aws_lambda_permission allow_bucket {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_name
  # aws_lambda_function.func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.data_source.arn
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
