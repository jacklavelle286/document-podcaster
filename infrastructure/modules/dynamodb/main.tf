resource "aws_dynamodb_table" "this" {
    name         = var.table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "jobId"

    attribute {
        name = "jobId"
        type = "S"
    }

    attribute {
        name = "status"
        type = "S"
    }

    attribute {
        name = "error"
        type = "S"
    }

    attribute {
        name = "inputKey"
        type = "S"
    }

    attribute {
        name = "outputKey"
        type = "S"
    }

    attribute {
        name = "createdAt"
        type = "S"
    }

    attribute {
        name = "updatedAt"
        type = "S"
    }

    attribute {
        name = "userId"
        type = "S"
    }
}