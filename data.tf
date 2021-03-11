# Prepare a zip file for deployment to AWS Lambda
data archive_file updater {
  type        = "zip"
  source_file = "${path.module}/lambda/updater.py"
  output_path = "${path.module}/lambda/updater.zip"
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
      "dynamodb:DescribeStream",
      "dynamodb:DescribeTable",
      "dynamodb:Get*",
      "dynamodb:Query",
      "dynamodb:Scan",
    ]

    resources = [
      aws_dynamodb_table.data_set.arn,
    ]
  }
}

data aws_iam_policy_document s3 {
  statement {
    effect = "Allow"

    actions = [
      "s3:*Object",
    ]

    resources = [
      "${aws_s3_bucket.data_source.arn}/*",
    ]
  }
}
