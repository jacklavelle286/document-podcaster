resource "aws_apigatewayv2_api" "http_api" {
  name          = "document-podcaster-api"
  protocol_type = "HTTP"

  # Allow your Vite dev server
  cors_configuration {
    allow_origins     = ["http://localhost:5173"]
    allow_methods     = ["GET", "POST", "OPTIONS"]
    allow_headers     = [
      "authorization",
      "content-type",
      "x-amz-date",
      "x-amz-security-token",
      "x-amz-user-agent",
      "x-requested-with"
    ]
    expose_headers    = ["content-type"]
    max_age           = 3600
    # If you need cookies or Authorization bearer tokens from the browser:
    # allow_credentials = true
  }
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


resource "aws_apigatewayv2_route" "get_voices" {
  api_id = aws_apigatewayv2_api.http_api.id
  route_key = "GET /getvoices"
  target    = "integrations/${aws_apigatewayv2_integration.get_voices_integrations.id}"
}

resource "aws_apigatewayv2_integration" "uploads_integration" {
  api_id                  = aws_apigatewayv2_api.http_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = var.uploader_function_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}

resource "aws_apigatewayv2_integration" "jobs_integration" {
  api_id                  = aws_apigatewayv2_api.http_api.id
  integration_type        = "AWS_PROXY"
  integration_uri         = var.get_job_function_arn
  integration_method      = "POST"
  payload_format_version  = "2.0"
}


resource "aws_apigatewayv2_integration" "get_voices_integrations" {
  api_id = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri = var.get_voices_function_arn
  integration_method = "GET"
  payload_format_version = "2.0"
}

# (Optional but recommended) auto-deploy a default stage so CORS changes go live immediately
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Lambda permissions for  integrations
resource "aws_lambda_permission" "uploads_api" {
  statement_id  = "AllowAPIGatewayInvokeUploads"
  action        = "lambda:InvokeFunction"
  function_name = var.uploader_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "jobs_api" {
  statement_id  = "AllowAPIGatewayInvokeJobs"
  action        = "lambda:InvokeFunction"
  function_name = var.get_job_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}


resource "aws_lambda_permission" "get_voices_api" {
  statement_id  = "AllowAPIGatewayInvokeJobs"
  action        = "lambda:InvokeFunction"
  function_name = var.get_voices_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}
