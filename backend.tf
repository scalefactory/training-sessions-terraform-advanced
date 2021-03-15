terraform {
  required_version = "~> 0.14.8"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.1.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.32.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.5.1"
    }
  }
}
