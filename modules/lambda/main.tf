data "archive_file" "zip" {

  type="zip"

  source_dir="../lambda-code"

  output_path="../lambda.zip"
}

resource "aws_lambda_function" "lambda" {

  function_name = var.function_name

  filename = data.archive_file.zip.output_path

  source_code_hash=data.archive_file.zip.output_base64sha256

  handler="lambda_function.lambda_handler"

  runtime="python3.12"

  role=var.role_arn
}
