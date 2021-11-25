resource "aws_s3_bucket" "source_media_convert" {
  bucket = "${var.source_bucket}"
  acl    = "private"
    force_destroy = true
  tags = {
    Name        = "Usage"
    Environment = "Media Convert"
  }
}

resource "aws_s3_bucket" "destination_media_convert" {
  bucket = "${var.destination_bucket}"
  acl    = "private"
    force_destroy = true
  tags = {
    Name        = "Usage"
    Environment = "Media Convert"
  }
}

resource "aws_s3_bucket_notification" "source_media_convert_notification" {
  bucket = aws_s3_bucket.source_media_convert.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.VOD_Lambda_Convert_Lambda.arn
    events              = ["s3:ObjectCreated:Put"]
    # filter_suffix       = ".log"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}