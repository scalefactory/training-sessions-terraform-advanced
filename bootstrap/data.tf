#
data aws_caller_identity current {}
data aws_region current {}
data aws_partition current {}

# Managed policy ARNs
data aws_arn read_only_access_policy {
  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/ReadOnlyAccess"
}

# Account ARN
data aws_arn current_account {
  arn = "arn:${data.aws_partition.current.partition}:iam::${local.account_id}:root"
}

# Generic role assumption policy
data aws_iam_policy_document assume_role {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = [
        data.aws_arn.current_account.arn,
      ]
    }
  }
}

# LambdaAdmin
data aws_iam_policy_document lambda_admin {
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"

      values = [
        "lambda.amazonaws.com",
      ]
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "lambda:AddLayerVersionPermission",
      "lambda:AddPermission",
      "lambda:CreateAlias",
      "lambda:CreateCodeSigningConfig",
      "lambda:CreateEventSourceMapping",
      "lambda:CreateFunction",
      "lambda:DeleteAlias",
      "lambda:DeleteCodeSigningConfig",
      "lambda:DeleteEventSourceMapping",
      "lambda:DeleteFunction",
      "lambda:DeleteFunctionCodeSigningConfig",
      "lambda:DeleteFunctionConcurrency",
      "lambda:DeleteFunctionEventInvokeConfig",
      "lambda:DeleteLayerVersion",
      "lambda:DeleteProvisionedConcurrencyConfig",
      "lambda:GetAccountSettings",
      "lambda:GetAlias",
      "lambda:GetCodeSigningConfig",
      "lambda:GetEventSourceMapping",
      "lambda:GetFunction",
      "lambda:GetFunctionCodeSigningConfig",
      "lambda:GetFunctionConcurrency",
      "lambda:GetFunctionConfiguration",
      "lambda:GetFunctionEventInvokeConfig",
      "lambda:GetLayerVersion",
      "lambda:GetLayerVersionPolicy",
      "lambda:GetPolicy",
      "lambda:GetProvisionedConcurrencyConfig",
      "lambda:InvokeAsync",
      "lambda:InvokeFunction",
      "lambda:ListAliases",
      "lambda:ListCodeSigningConfigs",
      "lambda:ListEventSourceMappings",
      "lambda:ListFunctionEventInvokeConfigs",
      "lambda:ListFunctions",
      "lambda:ListFunctionsByCodeSigningConfig",
      "lambda:ListLayerVersions",
      "lambda:ListLayers",
      "lambda:ListProvisionedConcurrencyConfigs",
      "lambda:ListTags",
      "lambda:ListVersionsByFunction",
      "lambda:PublishLayerVersion",
      "lambda:PublishVersion",
      "lambda:PutFunctionCodeSigningConfig",
      "lambda:PutFunctionConcurrency",
      "lambda:PutFunctionEventInvokeConfig",
      "lambda:PutProvisionedConcurrencyConfig",
      "lambda:RemoveLayerVersionPermission",
      "lambda:RemovePermission",
      "lambda:TagResource",
      "lambda:UntagResource",
      "lambda:UpdateAlias",
      "lambda:UpdateCodeSigningConfig",
      "lambda:UpdateEventSourceMapping",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionCodeSigningConfig",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateFunctionEventInvokeConfig",
    ]

    resources = [
      "arn:${data.aws_partition.current.partition}:lambda:${local.region}:${local.account_id}:codesigningconfig:*",
      "arn:${data.aws_partition.current.partition}:lambda:${local.region}:${local.account_id}:event-source-mapping:*",
      "arn:${data.aws_partition.current.partition}:lambda:${local.region}:${local.account_id}:function:*",
      "arn:${data.aws_partition.current.partition}:lambda:${local.region}:${local.account_id}:function:*:*",
      "arn:${data.aws_partition.current.partition}:lambda:${local.region}:${local.account_id}:layer:*",
      "arn:${data.aws_partition.current.partition}:lambda:${local.region}:${local.account_id}:layer:*:*",
    ]
  }
}
