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
      DEST_BUCKET = aws_s3_bucket.destination_media_convert.id
      DEST_PREFIX = "${var.company_name}"
      MEDIACONVERT_ROLE  = aws_iam_role.MediaConvert_Default_Role.arn
      MEDIACONVERT_TEMPLATE = "${var.MEDIACONVERT_TEMPLATE}"
      WATERMARK_IMAGE_LOCATION = aws_s3_bucket_object.object.id
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

# module "main_function" {
#   source        = "terraform-aws-modules/lambda/aws"
#   function_name = "${var.VOD_Lambda_Function_Name}2"
#   description   = "media convert"
#   handler       = "convert.handler"
#   runtime       = "python3.9"
#   source_path   = "../lambda-source-code/*"
#   memory_size   = 128
#   timeout       = 120
#   create_role   = false
#   lambda_role   = aws_iam_role.VODLambdaRole.arn
#   # tags          = var.resource_tags

#   # layers = [
#   #   module.ims_default_layer.lambda_layer_arn
#   # ]

#   environment_variables =  {
#       DEST_BUCKET = aws_s3_bucket.destination_media_convert.id
#       DEST_PREFIX = "${var.company_name}"
#       MEDIACONVERT_ROLE  = aws_iam_role.MediaConvert_Default_Role.arn
#       MEDIACONVERT_TEMPLATE = "${var.MEDIACONVERT_TEMPLATE}"
#       WATERMARK_IMAGE_LOCATION = aws_s3_bucket_object.object.id
#       Application       = "VOD"
#     }
# }
