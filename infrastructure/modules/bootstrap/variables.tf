variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}


variable "region" {
  description = "AWS region to deploy resources in"
  type        = string

}


variable "tags" {
  description = "Base tags to apply to resources"
  type        = map(string)
  default     = {}
}





variable "client_list_id" {
  description = "Client List id"
  type        = string
    sensitive = true
}



variable "oidc_url" {
  description = "OIDC URL"
  type        = string
  sensitive   = true
}

variable "trusted_sub" {
  type        = string
  description = "The OIDC subject (sub) claim for your pipeline’s service connection."
  sensitive   = true
}


variable "permissions_arn" {
  type = string
  default = "arn:aws:iam::aws:policy/AdministratorAccess"
}




variable "ecr_repos" {
  description = <<EOF
A list of ecr repos to create.  
Each item just needs a name: 
  • repo_name   (e.g. "lambda 1 repo")  
EOF
  type = list(object({
    repo_name = string
  }))
  default = []
}


variable "thumbprint_list" {
  description = "A list of OIDC thumbprints for GitHub"
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub OIDC thumbprint
}