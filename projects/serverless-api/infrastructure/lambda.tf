data "archive_file" "handler" {
  type        = "zip"
  source_file = "${path.module}/../src/handler.py"
  output_path = "${path.module}/handler.zip"
}

resource "aws_lambda_function" "visitor_counter" {
  function_name    = "maxify-sh-visitor-counter"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.12"
  handler          = "handler.handler"
  filename         = data.archive_file.handler.output_path
  source_code_hash = data.archive_file.handler.output_base64sha256
  architectures    = ["arm64"]
  timeout          = 10
  memory_size      = 128

  environment {
    variables = {
      TABLE_NAME     = aws_dynamodb_table.visitors.name
      ALLOWED_ORIGIN = var.allowed_origin
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.visitor_counter.function_name}"
  retention_in_days = 14
}
