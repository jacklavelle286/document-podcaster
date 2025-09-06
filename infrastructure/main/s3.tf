module "upload_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_upload_name
  enable_cors = true
  allowed_headers = ["*"]
  allowed_methods = ["POST"]
  allowed_origins = [var.allowed_origins]
}


module "outputs_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_outputs_name
  enable_cors = false
}