data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.root}/lambda-code"
  output_path = "${path.root}/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role    = var.role_arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.12"

  timeout     = 30
  memory_size = 128
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}
