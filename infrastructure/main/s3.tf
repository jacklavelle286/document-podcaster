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
  

}


module "outputs_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_outputs_name
  enable_cors = false
  enable_bucket_notification = false
}