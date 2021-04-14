terraform {
  required_version = "~> 0.14.10"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.1.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.36.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.5.2"
    }
  }
}
