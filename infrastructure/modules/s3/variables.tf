variable "bucket_name" {}
variable "enable_cors" {}
variable "allowed_headers" {
  default = null
  type    = list(string)
}
variable "allowed_origins" {
  default = null
  type    = list(string)

}
variable "allowed_methods" {
  default = null
  type    = list(string)

}

variable "enable_bucket_notification" {
    default = false
}

variable "bucket_lambda_function_arn" {
  default = null
}


variable "bucket_lambda_function_name" {
  default = null
}

variable "enable_bucket_notification" {
  default = false
}

variable "enable_bucket_policy" {
  default = false
}
variable "bucket_policy" {
  default = null
}

variable "bucket_policy_sid" {
  default = "sid"
}

variable "principal_type" {
  default = "Service"
}

variable "identifiers" {
  default = null
}


variable "actions" {
  default = null
}


variable "prefix" {
  default = null
}

