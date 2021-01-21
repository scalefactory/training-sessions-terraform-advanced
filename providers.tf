provider "aws" {
  region = "eu-west-1"
}

# terraform {
#   backend "s3" {
#     bucket = "snyk-codepipeline-terraform-state-450691171617-us-east-1-prod"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "CodePipelineTerraformStateLock-prod"
#   }
# }
