terraform {
  required_version = ">= 1.3.0"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }

    aws = {
      source = "hashicorp/aws"
      # Ensure this is valid for modules added during the session. 
      # i.e. cloudposse/cloudfront-s3-cdn/aws
      version = "~> 5.0.0"
    }
  }
}
