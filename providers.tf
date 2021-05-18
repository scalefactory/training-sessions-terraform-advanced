# Place a credentials file in the root of the Terraform repository in the
# format of:
#
# [tf_adv_training]
# aws_access_key_id=AKIAEXAMPLE
# aws_secret_access_key=foobarEXAMPLE
#
# This is not how we recommend you use credentials for real work, we recommend
# tools such as `aws-vault` to help manage your credentials.
#
# The %%ACCOUNT_ID%% here will want to be replaced with your account ID. You
# can do this with the following once you know your account ID:
#
# sed -i 's/%%ACCOUNT_ID%%/123456789012/g' providers.tf
#
# Where 123456789012 is your real account ID.
provider aws {
  region = "eu-west-1"

  # This profile configuration will be overridden if using aws-vault, so it's
  # safe to stay here.
  profile                 = "tf_adv_training"
  shared_credentials_file = "credentials"

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}

provider aws {
  alias  = "lambda_admin"
  region = "eu-west-1"

  assume_role {
    role_arn = "aws:arn:iam::%%ACCOUNT_ID%%:role/TfAdvLambdaAdmin"
  }

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}

provider aws {
  alias  = "read_only"
  region = "eu-west-1"

  assume_role {
    role_arn = "aws:arn:iam::%%ACCOUNT_ID%%:role/TfAdvReadOnly"
  }

  default_tags {
    tags = {
      Managed_by = "terraform"
    }
  }
}
