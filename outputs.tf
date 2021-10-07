output "s3_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "s3_website_url" {
  value = "http://${aws_s3_bucket.website.website_endpoint}"
}
