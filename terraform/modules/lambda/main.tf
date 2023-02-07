

resource "aws_iam_role" "lambda_role" {
  count = length(var.names)
  name  = "bs_${var.names[count.index]}_Lambda_Function_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

# create a log group to store log messages
# https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway
resource "aws_cloudwatch_log_group" "log_group" {
  count             = length(var.names)
  name              = "/aws/lambda/${var.names[count.index]}"
  retention_in_days = 30
}

# basic policy that allows lambdas to write to CloudWatch logs
# https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  count      = length(var.names)
  role       = aws_iam_role.lambda_role[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "zip_the_python_code" {
  count       = length(var.names)
  type        = "zip"
  source_dir  = var.source_dirs[count.index]
  output_path = "${var.source_dirs[count.index]}/${var.names[count.index]}.zip"
}

resource "aws_lambda_function" "tf_lambda_func" {
  count         = length(var.names)
  filename      = "${var.source_dirs[count.index]}/${var.names[count.index]}.zip"
  function_name = var.names[count.index]
  role          = aws_iam_role.lambda_role[count.index].arn
  handler       = "index.lambda_handler"
  runtime       = var.runtimes[count.index]
  depends_on    = [aws_iam_role_policy_attachment.lambda_policy]
}
