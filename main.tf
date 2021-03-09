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
