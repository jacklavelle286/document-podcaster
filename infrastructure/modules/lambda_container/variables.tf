variable "tags" {
  type = map(string)
  description = "Tags applied to this resource."
  default = {}
}


variable "function_name" {
  type = string
  description = "Name of the lambda function"
}


variable "memory_size" {
  description = "Memory assigned to your function."
  default = 128
}


variable "timeout" {
  description = "Lambdas timeout."
  default = 5
}

variable "package_type" {
  description = "Either image or zip - defaults to image."
  default = "Image"
}

variable "reserved_concurrent_executions" {
  description = "Concurrent executions."
  default = -1
}

variable "architectures" {
  type = list(string)
  description = "Instruction set architecture for lambda function. Default is x86_64"
  default = ["x86_64"]
}

variable "environment_variables" {
  description = "Key/value pairs that will be exposed as env vars in the Lambda."
  type        = map(string)
  default     = {}
}


variable "is_versioning" {
  default = true
  description = "Enables versioning for your function."
}

variable "image_uri" {
  description = "The location of the image which you want to deploy to your lambda function."
  type = string
}

variable "tracing_mode" {
  description = "Whether to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with sampled=1. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision."
  default = "Active"
}

# variable "lambda_role_name" {
#   description = "Lambda role name"
#   type = string
# }


variable "log_retention_in_days" {
  type = number
  default = 7
}

variable "policy_statements" {
  description = "A list of policy statements to include in the IAM policy document."
  type = list(object({
    sid            = string
    effect         = string
    actions        = list(string)
    resources      = list(string)
  }))
  default = []
}



