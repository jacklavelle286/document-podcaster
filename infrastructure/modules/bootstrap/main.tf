resource "aws_iam_openid_connect_provider" "github" {
  url            = var.oidc_url
  client_id_list = [var.client_list_id]
  tags           = local.default_tags
  thumbprint_list = var.thumbprint_list

}




resource "aws_iam_role" "github_oidc_role" {
  name = "github-federation"
  tags = local.default_tags
  assume_role_policy = jsonencode({
    Version : "2012-10-17",
    Statement : [{
      Effect : "Allow",
      Principal : { Federated : aws_iam_openid_connect_provider.github.arn },
      Action : "sts:AssumeRoleWithWebIdentity",
      Condition : {
        StringEquals : {
          "${replace(var.oidc_url, "https://", "")}:aud" = var.client_list_id
        },
        StringLike : {
          "${replace(var.oidc_url, "https://", "")}:sub" = var.trusted_sub
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "oidc_role" {
  policy_arn = var.permissions_arn
  role       = aws_iam_role.github_oidc_role.name
}


resource "aws_s3_bucket" "backend" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-${var.project}-${var.environment}"
  force_destroy = true
  tags          = local.default_tags
}



resource "aws_dynamodb_table" "lock" {
  name = "${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${var.project}-${var.environment}"

  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.default_tags
}



resource "aws_ecr_repository" "lambda_repo" {
  name         = "${var.project}-${var.environment}-${var.region}-${var.ecr_repos[count.index].repo_name}"
  force_delete = true
  count        = length(var.ecr_repos)
  tags         = local.default_tags
}


