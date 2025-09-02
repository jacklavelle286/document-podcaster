# s3 locals

locals {
  upload_bucket = "${var.environment}-${var.project}-${var.region}-upload"
}


