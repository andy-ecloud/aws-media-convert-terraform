resource "aws_lambda_function" "VOD_Lambda_Convert_Lambda" {
  filename      = "lambda.zip"
  function_name = var.VOD_Lambda_Function_Name
  role          = aws_iam_role.VODLambdaRole.arn
  handler       = "convert.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda.zip")

  runtime = "python3.7"

  environment {
    variables = {
      DestinationBucket = aws_s3_bucket.destination_media_convert.id
      MediaConvertRole  = aws_iam_role.MediaConvert_Default_Role.arn
      Application       = "VOD"
    }
  }

  timeout = 120
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.VOD_Lambda_Convert_Lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_media_convert.arn
}