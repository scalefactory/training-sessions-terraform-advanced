# Create role for Lambda
resource aws_iam_role lambda_role {
  name               = "${var.name}_lambda_role"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

# Attach basic AWS managed policy to lambda role
resource aws_iam_role_policy_attachment AWSLambdaBasicExecution {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach DynamoDB policy to lambda role
resource aws_iam_role_policy_attachment lambda_dynamodb {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# Attach S3 policy to lambda role
resource aws_iam_role_policy_attachment lambda_s3 {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Create DynamoDB policy
resource aws_iam_policy dynamodb_policy {
  path   = "/"
  policy = data.aws_iam_policy_document.dynamodb.json
}

# Create S3 policy
resource aws_iam_policy s3_policy {
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}
