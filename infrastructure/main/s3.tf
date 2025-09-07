module "upload_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_upload_name
  enable_cors = true
  allowed_headers = ["*"]
  allowed_methods = ["POST", "PUT"]
  allowed_origins = [var.allowed_origins]
  enable_bucket_notification = true
  bucket_lambda_function_arn = module.transcriber_function.function_arn
  bucket_lambda_function_name = module.transcriber_function.function_name
  enable_bucket_policy = false

}


module "outputs_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_outputs_name
  enable_cors = false
  enable_bucket_notification = false
  # enable_bucket_policy = true
  # principal_type = "Service"
  # identifiers = ["polly.amazonaws.com"]
  # actions = ["s3:PutObject"]
}

resource "aws_s3_bucket_policy" "this" {
  bucket = module.outputs_bucket.bucket_name
  policy = data.aws_iam_policy_document.this.json
}
data "aws_iam_policy_document" "this" {
  statement {
    sid    = "sid"
    effect = "Allow"

    principals {
      type        = "Service"        
      identifiers = ["polly.amazonaws.com"]  
    }

    actions = ["s3:PutObject"]

    resources = ["${module.outputs_bucket.bucket_arn}/*"]
  }
}