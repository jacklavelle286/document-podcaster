locals {
  default_tags = merge(
    {
      environment = var.environment
      project     = var.project
    },
    var.tags
  )

}

# Unified resource naming convention

locals {
    resource_name_prefix = "${var.environment}-${var.project}-${var.region}"
    s3_upload_name   = "${local.resource_name_prefix}-upload"
    s3_outputs_name  = "${local.resource_name_prefix}-outputs"
    dynamo_job_table_name = "${local.resource_name_prefix}-job"
}
