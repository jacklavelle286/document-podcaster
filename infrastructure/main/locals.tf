locals {
  default_tags = merge(
    {
      environment = var.environment
      project     = var.project
    },
    var.tags
  )

}

#s3 locals

locals {
  upload_name = "${var.environment}-${var.project}-${var.region}-upload"
}