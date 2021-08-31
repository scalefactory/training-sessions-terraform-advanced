# Follow the instructions in the training materials to set up an AWS profile
# named "advanced-tf-training"
#
# ⓘ  This is not how The Scale Factory recommend you use credentials for real work;
# we recommend tools such as `aws-vault` to help manage your credentials.
#
# The %%ACCOUNT_ID%% here will want to be replaced with your assigned AWS account ID.
# You can do this with the following command once you know your account ID:
#
# sed -i 's/%%ACCOUNT_ID%%/123456789012/g' providers.tf
#
# For Mac users
# sed -i .bak 's/%%ACCOUNT_ID%%/123456789012/g' providers.tf
#
# Where 123456789012 is your real account ID.
provider "aws" {
  region = "eu-west-1"

  # This profile configuration will be overridden if using aws-vault, so it's
  # safe to stay here.
  profile                 = "advanced-tf-training"

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}

provider "aws" {
  alias                   = "lambda_admin"
  region                  = "eu-west-1"
  profile                 = "advanced-tf-training"

  assume_role {
    role_arn = "arn:aws:iam::%%ACCOUNT_ID%%:role/TfAdvLambdaAdmin"
  }

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}

provider "aws" {
  alias                   = "read_only"
  region                  = "eu-west-1"
  profile                 = "advanced-tf-training"

  assume_role {
    role_arn = "arn:aws:iam::%%ACCOUNT_ID%%:role/TfAdvReadOnly"
  }

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}
