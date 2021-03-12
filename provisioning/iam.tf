# IAM Roles
resource aws_iam_role lambda_admin {
  name               = "TfAdvLambdaAdmin"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource aws_iam_role read_only {
  name               = "TfAdvReadOnly"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Create IAM policies
resource aws_iam_policy lambda_admin {
  name        = "TfAdvLambdaAdmin"
  description = "Allow admin access to AWS Lambda"
  policy      = data.aws_iam_policy_document.lambda_admin.json
}

# Attach IAM Policies
resource aws_iam_role_policy_attachment lambda_admin {
  role       = aws_iam_role.lambda_admin.name
  policy_arn = aws_iam_policy.lambda_admin.arn
}

resource aws_iam_role_policy_attachment read_only {
  role       = aws_iam_role.read_only.name
  policy_arn = data.aws_arn.read_only_access_policy.arn
}
