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