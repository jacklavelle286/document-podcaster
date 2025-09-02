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
    resource_name_prefix = "${var.project}-${var.environment}-${var.region}"
    s3_upload_name   = "${local.resource_name_prefix}-upload"
    s3_outputs_name  = "${local.resource_name_prefix}-outputs"
    dynamo_job_table_name = "${local.resource_name_prefix}-job"
    get_job_repo_name = "${local.resource_name_prefix}-get-job"
    transcriber_repo_name = "${local.resource_name_prefix}-transcriber"
    uploader_repo_name = "${local.resource_name_prefix}-uploader"

}


