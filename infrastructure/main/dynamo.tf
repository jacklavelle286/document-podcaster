module "job_table" {
  source = "../modules/dynamodb"
  table_name = local.dynamo_job_table_name
}