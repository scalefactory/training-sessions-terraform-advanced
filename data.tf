# Get our current region
data aws_region current {
}

# Get our caller identity
data aws_caller_identity current {
}

# Prepare a zip file for deployment to AWS Lambda
data archive_file updater {
  type             = "zip"
  source_file      = "${path.module}/lambda/updater.py"
  output_file_mode = "0755"
  output_path      = "${path.module}/lambda/updater.zip"
}

# Assume role policy for Lambda
data aws_iam_policy_document lambda_assume_role_policy {
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

# Policy allowing access to DynamoDB for Lambda
data aws_iam_policy_document dynamodb {
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

# Policy allowing access to S3
data aws_iam_policy_document s3 {
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
