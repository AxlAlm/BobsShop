

resource "aws_iam_role" "lambda_role" {
  name = "bs_Lambda_Function_Role"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
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
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.lambda_handler"
  runtime       = var.runtimes[count.index]
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
