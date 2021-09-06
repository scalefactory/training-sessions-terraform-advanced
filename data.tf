# Get our current region
data "aws_region" "current" {
  provider = aws.read_only
}

# Get our caller identity
data "aws_caller_identity" "current" {
  provider = aws.read_only
}

# Get our AWS partition - eg "aws" (default), or "aws-us-gov" (US GovCloud regions)"
data "aws_partition" "current" {
}