variable "aws_account_id" {}
variable "region" {}
variable "project" {}
variable "environment" {}

variable "tags" {
  description = "Base tags to apply to resources"
  type        = map(string)
  default     = {}
}


