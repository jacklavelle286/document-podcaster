locals {
  default_tags = merge(
    {
      environment = var.environment
      project     = var.project
    },
    var.tags
  )

}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}