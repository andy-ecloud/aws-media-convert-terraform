variable "company_name" {
  type    = string
  default = "company"
}

variable "AWS_REGION" {
  type    = string
  default = "us-east-2"

}

variable "source_bucket" {
  type    = string
  default = "andy-mediaconvert"

}

variable "destination_bucket" {
  type    = string
  default = "andy-mediaconvert-dest"

}

variable "MediaConvert_Default_Role_Name" {
  type    = string
  default = "MediaConvert_Default_Role"
}

variable "VOD_Lambda_Role_Name" {
  type    = string
  default = "VODLambdaRole"
}

variable "VOD_Lambda_Function_Name" {
  type    = string
  default = "VODLambdaConvert"
}

## AWS Credential and Account Information
variable "AWS_PROFILE" {
  type    = string
  default = "default"
}