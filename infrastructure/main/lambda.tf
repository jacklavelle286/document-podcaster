# module "get_job_function" {
#   source = "../modules/lambda_container"
#   image_uri        = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.get_job_repo_name}:latest"
#   function_name = "get_job"
#   policy_statements = [
#     {
#       sid       = "Logs"
#       effect    = "Allow"
#       actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
#       resources = ["arn:aws:logs:*:*:*"]
#     },
#     {
#       sid       = "test"
#       effect    = "Allow"
#       actions   = ["*"]
#       resources = ["*"]
#     }
#   ]
# }



# module "transcriber_function" {
#   source = "../modules/lambda_container"
#   image_uri        = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.transcriber_repo_name}:latest"
#   function_name = "transcriber"
#     policy_statements = [
#     {
#       sid       = "Logs"
#       effect    = "Allow"
#       actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
#       resources = ["arn:aws:logs:*:*:*"]
#     },
#     {
#       sid       = "test"
#       effect    = "Allow"
#       actions   = ["*"]
#       resources = ["*"]
#     }
#   ]
# }

# module "uploader_function" {
#   source = "../modules/lambda_container"
#   image_uri        = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${local.uploader_repo_name}:latest"
#   function_name = "uploader"
#     policy_statements = [
#     {
#       sid       = "Logs"
#       effect    = "Allow"
#       actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
#       resources = ["arn:aws:logs:*:*:*"]
#     },
#     {
#       sid       = "test"
#       effect    = "Allow"
#       actions   = ["*"]
#       resources = ["*"]
#     }
#   ]
# }
