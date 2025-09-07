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

resource "aws_lambda_permission" "allow_s3_invoke_from_upload_bucket" {
  count = var.enable_bucket_notification ? 1 : 0
  statement_id  = "AllowS3InvokeFromUploadBucket"
  action        = "lambda:InvokeFunction"
  function_name = var.bucket_lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.this.arn
}


resource "aws_s3_bucket_policy" "this" {
  count = var.enable_bucket_policy ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.this[count.index].json
}

data "aws_iam_policy_document" "this" {
  count = var.enable_bucket_policy ? 1 : 0
  statement {
    sid = var.bucket_policy_sid
    effect = var.bucket_effect

    principals {
      type = var.principal_type
      identifiers = var.identifiers
    }

    actions = var.actions

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]  
  }
}