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


resource "aws_s3_bucket_notification" "this" {
  count = var.enable_bucket_notification ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  lambda_function {
    lambda_function_arn = var.bucket_lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}