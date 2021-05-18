output lambda_role {
  value = aws_iam_role.lambda_role.arn
}

output s3_bucket {
  value = aws_s3_bucket.data_source.bucket
}

output s3_website_url {
  value = "https://${aws_s3_bucket.website.website_endpoint}"
}
