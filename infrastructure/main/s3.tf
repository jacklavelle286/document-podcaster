module "upload_bucket" {
  source = "../modules/s3"
  bucket_name = local.upload_name
}