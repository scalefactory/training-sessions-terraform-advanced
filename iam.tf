# Create role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "${var.name}_lambda_role"
  description        = "Execution role for Lambda ${local.lambda_name}"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

# Attach basic AWS managed policy to lambda role
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach DynamoDB policy to lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# Attach S3 policy to lambda role
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Create DynamoDB policy
resource "aws_iam_policy" "dynamodb_policy" {
  path   = "/"
  policy = data.aws_iam_policy_document.dynamodb.json
}

# Create S3 policy
resource "aws_iam_policy" "s3_policy" {
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}

# Assume role policy for Lambda role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

# Policy allowing access to DynamoDB
data "aws_iam_policy_document" "dynamodb" {
  statement {
    effect = "Allow"

    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:BatchWriteItem",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = [
      aws_dynamodb_table.data_set.arn,
    ]
  }
}

# Policy allowing access to S3 objects
data "aws_iam_policy_document" "s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:CopyObject",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:HeadObject",
      "s3:PutObject",
      "s3:RestoreObject",
    ]

    resources = [
      "${aws_s3_bucket.data_source.arn}/*",
    ]
  }
}

