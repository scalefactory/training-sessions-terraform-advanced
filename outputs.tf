output lambda_role {
  value = aws_iam_role.lambda_role.arn
}

output s3_bucket {
  value = aws_s3_bucket.data_source.bucket
}
