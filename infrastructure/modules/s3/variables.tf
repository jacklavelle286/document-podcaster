variable "bucket_name" {}
variable "enable_cors" {}
variable "allowed_headers" {
    default = null
}
variable "allowed_origins" {
    default = null
}
variable "allowed_methods" {
    default = null
}