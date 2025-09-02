resource "aws_apigatewayv2_api" "http_api" {
    name          = "document-podcaster-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "post_uploads" {
    api_id    = aws_apigatewayv2_api.http_api.id
    route_key = "POST /uploads"
    target    = "integrations/${aws_apigatewayv2_integration.uploads_integration.id}"
}

resource "aws_apigatewayv2_route" "get_jobs" {
    api_id    = aws_apigatewayv2_api.http_api.id
    route_key = "GET /jobs/{jobId}"
    target    = "integrations/${aws_apigatewayv2_integration.jobs_integration.id}"
}


resource "aws_apigatewayv2_integration" "uploads_integration" {
    api_id           = aws_apigatewayv2_api.http_api.id
    integration_type = "AWS_PROXY"
    integration_uri  = var.uploader_function_arn
    integration_method = "POST"
    payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "jobs_integration" {
    api_id           = aws_apigatewayv2_api.http_api.id
    integration_type = "AWS_PROXY"
    integration_uri  = var.get_job_function_arn
    integration_method = "POST"
    payload_format_version = "2.0"
}

resource "aws_lambda_permission" "uploads_api" {
    statement_id  = "AllowAPIGatewayInvokeUploads"
    action        = "lambda:InvokeFunction"
    function_name = var.uploader_function_name
    principal     = "apigateway.amazonaws.com"
    source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
