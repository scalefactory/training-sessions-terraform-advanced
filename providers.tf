# Follow the instructions in the training materials to set up an AWS profile
# named "advanced-tf-training"
#
# ⓘ  This is not how The Scale Factory recommend you use credentials for real work;
# we recommend tools such as `aws-vault` to help manage your credentials.

provider "aws" {
  region = "eu-west-1"

  # This profile configuration will need to be commented out if using aws-vault.
  profile = "advanced-tf-training"

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}
