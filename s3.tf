data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "source_media_convert" {
  bucket_prefix = var.source_bucket
  acl           = "private"
  force_destroy = true
  tags = {
    Name        = "Usage"
    Environment = "Media Convert"
  }
}

# resource "aws_s3_bucket_policy" "source_media_convert_policy" {
#   bucket = aws_s3_bucket.source_media_convert.id

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression's result to valid JSON syntax.
#   policy = jsonencode({
#       "Version":"2012-10-17",
#       "Statement":[
#         {
#           "Sid":"PublicRead",
#           "Effect":"Allow",
#           "Principal":{"AWS":"*"}
#           "Action":["s3:GetObject","s3:GetObjectVersion"],
#           "Resource":["${aws_s3_bucket.source_media_convert.arn}/*"]
#         }
#       ]
#     }
#   )
# }

resource "aws_s3_bucket_public_access_block" "source_media_convert_block_public_access" {
  bucket = aws_s3_bucket.source_media_convert.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "destination_media_convert" {
  bucket_prefix = "${var.destination_bucket}"
  acl           = "private"
  force_destroy = true
  tags = {
    Name        = "Usage"
    Environment = "Media Convert"
  }
}

resource "aws_s3_bucket_public_access_block" "destination_media_convert_block_public_access" {
  bucket = aws_s3_bucket.destination_media_convert.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "source_media_convert_notification" {
  bucket = aws_s3_bucket.source_media_convert.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.VOD_Lambda_Convert_Lambda.arn
    events              = ["s3:ObjectCreated:Put"]
    # filter_suffix       = ".log"
  }

  # depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.source_media_convert.id
  key    = "Watermark.png"
  source = "Watermark.png"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  # etag = filemd5("path/to/file")
}

# resource "random_pet" "bucket" {

# }

# output "bucket_random" {
#   value = random_pet.bucket
# }