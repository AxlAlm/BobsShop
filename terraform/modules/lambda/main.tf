

resource "aws_iam_role" "lambda_role" {
  name = "${var.service_name}_Lambda_Function_Role"
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
  # count             = length(var.names)
  # name              = "/aws/lambda/${var.names[count.index]}"
  name              = "/aws/lambda/${var.service_name}"
  retention_in_days = 30
}

# basic policy that allows lambdas to write to CloudWatch logs
# https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  # count      = length(var.names)
  # role       = aws_iam_role.lambda_role[count.index].name
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "archive_file" "code_zip" {
  count       = length(var.names)
  type        = "zip"
  source_dir  = var.paths_to_lambda_functions[count.index]
  output_path = "${var.paths_to_lambda_functions[count.index]}/${var.names[count.index]}.zip"
}

resource "aws_lambda_function" "tf_lambda_func" {
  count         = length(var.names)
  filename      = "${var.paths_to_lambda_functions[count.index]}/${var.names[count.index]}.zip"
  function_name = var.names[count.index]
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = var.runtime
  timeout       = var.timeouts[count.index]
  memory_size   = var.memory_sizes[count.index]
  depends_on    = [aws_iam_role_policy_attachment.lambda_policy]
  layers        = ["${aws_lambda_layer_version.python37-pandas-layer.arn}"]
}


resource "aws_lambda_layer_version" "layer" {
  filename            = var.path_to_layer_zip
  layer_name          = "python-${var.service_name}-layer"
  source_code_hash    = filebase64sha256(var.path_to_layer_zip)
  compatible_runtimes = [var.runtime]
}
