module "boostrap" {
  source = "../modules/bootstrap"
  project = var.project
  environment = var.environment
  region = var.region
  trusted_sub = "repo:jacklavelle286/document-podcaster:environment:${var.environment}"
  client_list_id = "sts.amazonaws.com"
  oidc_url = "https://token.actions.githubusercontent.com"
    ecr_repos = [
    {
      repo_name = "uploader"
    },
    {
      repo_name = "transcriber"
    }
  ]
}