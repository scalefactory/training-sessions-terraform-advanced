###########################
resource "aws_dynamodb_table" "data_set" {
  name           = "${var.name}_data_set"
  hash_key       = "name"
  write_capacity = 1
  read_capacity  = 1
  attribute {
    name = "name"
    type = "S"
  }
}

resource "aws_s3_bucket" "data_source" {
  bucket = "${var.name}-data-source"
}
# Create policy

# Create role
data "aws_iam_policy_document" "lambda-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "${var.name}_lambda_role"
  path               = "/lambda/"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role-policy.json

}

# Attach basic policy
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach dynamodb policy
resource "aws_iam_role_policy_attachment" "LambdaDynamoDB" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_policy" "dynamodb_policy" {
  path   = "/"
  policy = data.aws_iam_policy_document.dynamodb.json
}

data "aws_iam_policy_document" "dynamodb" {
  statement {
    actions = [
      "dynamodb:BatchGet*",
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan"
    ]
    resources = [
      aws_dynamodb_table.data_set.arn
    ]
  }
}

# Attach S3 Policy
resource "aws_iam_role_policy_attachment" "LambdaS3" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}


resource "aws_iam_policy" "s3_policy" {
  path   = "/"
  policy = data.aws_iam_policy_document.s3.json
}

data "aws_iam_policy_document" "s3" {
  statement {
    actions = [
      "s3:*Object"
    ]
    resources = [
      "${aws_s3_bucket.data_source.arn}/*"
    ]
  }
}