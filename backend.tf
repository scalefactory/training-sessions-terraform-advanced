terraform {
  required_version = "~> 0.14.8"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.1.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.31.0"
    }
  }
}
