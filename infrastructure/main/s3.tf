resource "aws_s3_bucket" "upload_bucket" {
  bucket = local.upload_bucket
}