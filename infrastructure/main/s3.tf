module "upload_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_upload_name
}

module "outputs_bucket" {
  source = "../modules/s3"
  bucket_name = local.s3_outputs_name
}