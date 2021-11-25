resource "aws_iam_role" "MediaConvert_Default_Role" {
  name = var.MediaConvert_Default_Role_Name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "mediaconvert.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "MediaConvert_Default_Role_Policy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:Get*",
            "s3:List*"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.source_bucket}/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "s3:Put*"
          ],
          "Resource" : [
            "arn:aws:s3:::${var.destination_bucket}/*"
          ]
        }
      ]
    })
  }
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

resource "aws_iam_role" "VODLambdaRole" {
  name = var.VOD_Lambda_Role_Name
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
  managed_policy_arns = [data.aws_iam_policy.AmazonS3FullAccess.arn, data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn]
  inline_policy {
    name = "VODLambdaPolicy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*",
          "Effect" : "Allow",
          "Sid" : "Logging"
        },
        {
          "Action" : [
            "iam:PassRole"
          ],
          "Resource" : [
            "${aws_iam_role.MediaConvert_Default_Role.arn}"
          ],
          "Effect" : "Allow",
          "Sid" : "PassRole"
        },
        {
          "Action" : [
            "mediaconvert:*"
          ],
          "Resource" : [
            "*"
          ],
          "Effect" : "Allow",
          "Sid" : "MediaConvertService"
        }
      ]
      }
    )
  }
}
