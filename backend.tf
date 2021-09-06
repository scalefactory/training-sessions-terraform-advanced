terraform {
  required_version = "~> 1.0.3"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.40.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.9.4"
    }
  }
}
