module "get_job_function" {
  source           = "../modules/lambda_container"
  image_uri        = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.get_job_repo_name}:latest"
  function_name    = "${local.resource_name_prefix}-get_job"
  lambda_role_name = "${local.resource_name_prefix}-get-job-role"
  policy_statements = [
    {
      sid       = "Logs"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:*"]
    },
    {
      sid       = "test"
      effect    = "Allow"
      actions   = ["*"]
      resources = ["*"]
    }
  ]
}



module "transcriber_function" {
  source           = "../modules/lambda_container"
  image_uri        = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.transcriber_repo_name}:latest"
  function_name    = "${local.resource_name_prefix}-transcriber"
  lambda_role_name = "${local.resource_name_prefix}-transcriber-role"
  timeout = 300
  memory_size = 500
  environment_variables = {
    DESTINATION_BUCKET = module.outputs_bucket.bucket_name
  }



  policy_statements = [
    {
      sid       = "Logs"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:*"]
    },
    {
      sid       = "polly"
      effect    = "Allow"
      actions   = ["polly:StartSpeechSynthesisTask"]
      resources = ["*"]
    },

    {
      sid = "s3"
      effect = "Allow"
      actions = [ "s3:PutObject" ]
      resources = [ "${module.upload_bucket.bucket_arn}/*"]
    }
  ]
}

module "uploader_function" {
  source                = "../modules/lambda_container"
  image_uri             = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.uploader_repo_name}:latest"
  function_name         = "${local.resource_name_prefix}-uploader"
  lambda_role_name      = "${local.resource_name_prefix}-uploader-role"
  log_retention_in_days = 3
  environment_variables = {
    UPLOAD_BUCKET = module.upload_bucket.bucket_name
  }

  policy_statements = [
    {
      sid       = "Logs"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:*"]
    },
    {
      sid       = "test"
      effect    = "Allow"
      actions   = ["*"]
      resources = ["*"]
    }
  ]
}


module "get_voices_function" {
  source                = "../modules/lambda_container"
  image_uri             = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.get_voices_repo_name}:latest"
  function_name         = "${local.resource_name_prefix}-get-voices"
  lambda_role_name      = "${local.resource_name_prefix}-get-voices-role"
  log_retention_in_days = 3

  policy_statements = [
    {
      sid       = "Logs"
      effect    = "Allow"
      actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
      resources = ["arn:aws:logs:*:*:*"]
    },
    {
      sid       = "test"
      effect    = "Allow"
      actions   = ["polly:DescribeVoices"]
      resources = ["*"]
    }
  ]
}
