resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count = var.enable_cors ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  cors_rule {
    allowed_headers = var.allowed_headers
    allowed_methods = var.allowed_methods
    allowed_origins = var.allowed_origins
  }
}