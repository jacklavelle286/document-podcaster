resource "aws_dynamodb_table" "this" {
    name         = var.table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "jobId"

    attribute {
        name = "jobId"
        type = "S"
    }

}